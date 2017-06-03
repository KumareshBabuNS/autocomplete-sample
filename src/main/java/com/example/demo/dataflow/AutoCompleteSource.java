package com.example.demo.dataflow;

import java.util.ArrayList;

public class AutoCompleteSource {
    String prefix;
    ArrayList<String> candidates;

    public AutoCompleteSource(String prefix, ArrayList<String> candidates) {
        this.prefix = prefix;
        this.candidates = candidates;
    }

    public String getPrefix() {
        return prefix;
    }

    public void setPrefix(String prefix) {
        this.prefix = prefix;
    }

    public ArrayList<String> getCandidates() {
        return candidates;
    }

    public void setCandidates(ArrayList<String> candidates) {
        this.candidates = candidates;
    }
}
