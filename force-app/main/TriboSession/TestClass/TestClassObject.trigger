/**
 * @description: Unique trigger for TestClassObject__c
 * @author: Guilherme Zwipp
 */
trigger TestClassObject on TestClassObject__c ( after insert ) {
    new TestClassObjectHandler().run();
}