trigger ContactTriggerForSkillUp on Trainee__c (after insert,after update, after delete) {
    
    if(!Process_Deactivation__c.getInstance().Disable_Trigger__c) {
         System.debug('Bypassing trigger due to custom setting');
         return;
     }
    
    if(Trigger.isAfter){
        if(Trigger.isInsert || Trigger.isUpdate || Trigger.isDelete ){
            ContactTriggerHandler.countAndCostOfTraining(Trigger.new);
        }
    }
   
}