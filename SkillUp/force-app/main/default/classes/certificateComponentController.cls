public class certificateComponentController {    
    public String recordId {get;set;}
    public String traineeName {get;set;}
    public String courseName {get;set;}
    public String trainerName {get;set;}
    public Date completionDate {get;set;}
    public List<Trainee__c> traineeList {get;set;}
    Set<Id> commonSet {get;set;}
    public List<Course__c> courselist {get;set;}
    public List<Trainer__c> trainerlist {get;set;}
    public certificateComponentController() {
       getData();
    }
    //getData() Retrieve the data required for the certificate component from Trainee , Course and Trainer objects.
    public List<sObject> getData(){
        commonSet = New Set<Id>();
        
        //Getting the Trainee Id from the Trainee Detail page and setting it to recordId variable
        recordId = ApexPages.currentPage().getParameters().get('id');
        system.debug('record id '+recordId);
         if(String.isNotEmpty(recordId))
         {
             traineeList = [SELECT Name,Completion_Date__c,Course__c  FROM Trainee__c where Id=:recordId LIMIT 1];
        	 for( Trainee__c traineeObj : traineeList )
        	 {
                   if(traineeObj.Course__c != Null) 
                       commonSet.add(traineeObj.Course__c);
            	   traineeName = traineeObj.Name;
            	   completionDate = traineeObj.Completion_Date__c;
             }
        	 courselist=[Select Name,Trainer__c from Course__c Where Id IN: commonSet LIMIT 1];
        	 for( Course__c courseObj : courselist )
             {
                   if(courseObj.Trainer__c != Null) 
                       commonSet.add(courseObj.Trainer__c);
            	   courseName = courseObj.Name;
            
             }
             trainerlist=[Select Trainer_Name__c from Trainer__c where Id IN: commonSet LIMIT 1];
             for( Trainer__c trainerObj : trainerlist )
             {
            	trainerName = trainerObj.Trainer_Name__c ;
        	 }
             System.debug('new trainee list '+traineeList);
             return traineeList;
         }
        
        else
        {
            return new List<Trainee__c>();
        }
    }
  }