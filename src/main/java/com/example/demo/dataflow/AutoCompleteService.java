package com.example.demo.dataflow;


import com.google.cloud.bigquery.*;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Service
public class AutoCompleteService implements AutoCompleteRepository{

    @Value("${complete.table_name}")
    public String tableName;


    @Override
    @Cacheable("AutoCompleteSource")
    public AutoCompleteSource getAutoComplete(String prefix) throws Exception {

        ArrayList<String> results = new ArrayList<String>();

        BigQuery bigquery = BigQueryOptions.getDefaultInstance().getService();

        String queryString = String.format("SELECT tag, count FROM `%s` , UNNEST(tags) WHERE prefix = \'%s\' LIMIT 100", tableName, prefix);

        QueryJobConfiguration queryConfig =
                QueryJobConfiguration.newBuilder(queryString)
                        .setUseLegacySql(false)
                        .setUseQueryCache(true)
                        .build();
        JobId jobId = JobId.of(UUID.randomUUID().toString());
        Job queryJob = bigquery.create(JobInfo.newBuilder(queryConfig).setJobId(jobId).build());
        queryJob = queryJob.waitFor();


        if (queryJob == null) {
            throw new RuntimeException("Job no longer exists");
        } else if (queryJob.getStatus().getError() != null) {
            throw new RuntimeException(queryJob.getStatus().getError().toString());
        }

        QueryResponse response = bigquery.getQueryResults(jobId);
        QueryResult result = response.getResult();

        while (result != null) {
            for (List<FieldValue> row : result.iterateAll()) {
                results.add(row.get(0).getStringValue());
            }

            result = result.getNextPage();
        }
        return new AutoCompleteSource(prefix, results);
    }

}
