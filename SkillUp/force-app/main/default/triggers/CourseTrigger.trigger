trigger CourseTrigger on Course__c (after update) {
    
    if(!Process_Deactivation__c.getInstance().Disable_Trigger__c) {
         System.debug('Bypassing trigger due to custom setting');
         return;
     }
    
    if(Trigger.isAfter){
        if(Trigger.isUpdate){
            Set<Id> setofId = new Set<Id>();
            for(Course__c courseid : trigger.new){
                setofId.add(courseid.Id);
            }
            CourseHandler.getCourseStatusAndUpdateTrainingStatus(setofId);
            
        }
    }
}