public class checkCRUDForLWC {
    @AuraEnabled
    public static Trainee__c createTraineeRecord(Id courseId, Id contactId){
        Trainee__c traineeObject = new Trainee__c();
        //Contact conObject = new Contact();
        traineeObject.Course__c = courseId;
        traineeObject.Contact__c = contactId;
        traineeObject.Name = traineeObject.Contact__r.Name;
        //traineeObject.Corporation__c = conObject.AccountId;
        if(isCreateable('Trainee__c')==true){
            insert traineeObject;
            return traineeObject;
        }
        return null;
    }
    public static Boolean isCreateable(String sObjectType){
        SObjectType schemaType = Schema.getGlobalDescribe().get(sObjectType);
        return schemaType.getDescribe().isCreateable();
    }
}