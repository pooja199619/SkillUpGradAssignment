public class certificateerorController {
    
    public Trainee__c traineelist {get;set;}
    public Course__c courselist {get;set;}
    public certificateerorController() {
        traineelist=[SELECT Name,Completion_Date__c,Course__c  FROM Trainee__c where Id=:ApexPages.currentPage().getParameters().get('id') LIMIT 1000];
        courselist=[Select Name,Trainer__c from Course__c Where id=:traineelist.Course__c LIMIT 1000];
       
        
    }
  }