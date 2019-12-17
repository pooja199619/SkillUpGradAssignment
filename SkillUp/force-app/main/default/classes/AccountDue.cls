global class AccountDue implements Database.Batchable<sobject>
{
	List<AggregateResult> trainee_AggList = new List<AggregateResult>();
    
    global Database.QueryLocator start(Database.BatchableContext BC) 
    {
        return Database.getQueryLocator([
            SELECT 
                Id,Last_Month_Dues__c,
                (SELECT Id, Name FROM Contacts WHERE Primary__c=true)
            FROM
                Account
            WHERE
                Id
            IN
                (SELECT AccountId FROM Contact WHERE Primary__c=true)]);
    }
    
    global void execute(Database.BatchableContext BC, List<Account> scope) 
    {
        System.debug('scope -- '+ scope);
        Set<Id> commonSet= new Set<Id>();
        for(Account acountobj : scope)
        {
                if(acountobj.Id !=null)
                  commonSet.add(acountobj.Id);
        }
        trainee_AggList = [Select Corporation__c,Sum(Course_fee__c) Total_Due 
                                                 from Trainee__c where Corporation__c in : commonSet
                                                 Group By Corporation__c ];
        List<Account> listofAccountsToUpdate = new List<Account>();
        for(Account acc : scope) {
            Map<String, Double> mapOfAccountsAndLastMonthDues = new Map<String, Double>();
			
            for(AggregateResult aggResult : trainee_AggList)
            {
                acc.Id = (String) aggResult.get('Corporation__c');
                acc.Last_Month_Dues__c = (Double) aggResult.get('Total_Due');
                listofAccountsToUpdate.add(acc);
            }
        }
		System.debug('List Of Updated Accounts ' + listofAccountsToUpdate);
        update listofAccountsToUpdate;
    }
    global void finish(Database.BatchableContext BC) 
    {
        List<Contact> listOfContacts = [SELECT Id, Name, Email, Account.Last_Month_Dues__c,Account.Name, AccountId FROM Contact 
                                        WHERE Primary__c=true];
        
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        
        for(Contact con : listOfContacts ) 
        {	
			Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
			List<String> sendTo = new List<String>();
			sendTo.add(con.Email);
			mail.setToAddresses(sendTo);
			mail.setSenderDisplayName('Account Last Month Due');
			mail.setSubject('Account Last Month Due !!!');
            String body = 'Hello ' + con.Name + ',' + '<br>' +
                ' This mail is to provide the information related to '+ con.Account.Name +' Last Month Due.'
                + 'Your this month due is ' + con.Account.Last_Month_Dues__c +'<br><br>'+ 
                'Thanks & Regards' + '<br><br>'+'Team SkillUp';
            mail.setHtmlBody(body);
            mails.add(mail);
    	}
        Messaging.sendEmail(mails);
	}
}