package com.example.demo;

import com.example.demo.dataflow.AutoCompleteRepository;
import com.example.demo.dataflow.AutoCompleteService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
public class AutoCompleteController {

    @Autowired
    AutoCompleteRepository autoCompleteService;

    @RequestMapping("/autocomplete")
    public List<String> autocomplete(@RequestParam("prefix")  String prefix) throws Exception {
        return autoCompleteService.getAutoComplete(prefix).getCandidates();
    }
}
