package com.example.demo.dataflow;

import org.junit.Assert;
import org.junit.Ignore;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;

import static org.junit.Assert.*;


@RunWith(SpringRunner.class)
@SpringBootTest
public class AutoCompleteServiceTest {

    @Autowired
    AutoCompleteRepository autoCompleteService;


    @Test
    public void test() throws Exception {
        Assert.assertEquals(autoCompleteService.getAutoComplete("a").getCandidates().size(), 2);
    }

}