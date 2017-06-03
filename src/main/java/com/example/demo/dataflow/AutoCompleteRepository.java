package com.example.demo.dataflow;


import java.util.ArrayList;

public interface AutoCompleteRepository {
    AutoCompleteSource getAutoComplete(String prefix) throws Exception;
}
