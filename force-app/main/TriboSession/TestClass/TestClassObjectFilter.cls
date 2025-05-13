/**
 * @description: Filter to TestClassObjects objects in test context
 * @author: Guilherme Zwipp
 */
public with sharing class TestClassObjectFilter extends Filter {

    public static TestClassObjectFilter instance = null;

    public static TestClassObjectFilter getInstance() {
        if( instance == null ) instance = new TestClassObjectFilter();
        return instance;
    }

}