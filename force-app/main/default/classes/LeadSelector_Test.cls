/**
 * Created by david on 05.09.2023.
 */
@IsTest
private class LeadSelector_Test {
    @IsTest
    private static void selectByCountryNamesTest(){
        //Given
        new SObjectBuilder(Lead.SObjectType)
                .put(Lead.LastName,'Test')
                .put(Lead.Company,'Test')
                .put(Lead.Status,'Open - Not Contacted')
                .put(Lead.alpha2Code__c,'CZ')
                .put(Lead.alpha3Code__c,'CZE')
                .put(Lead.capital__c,'Prague')
                .put(Lead.Region__c,'Europe')
                .put(Lead.Country,'CZE')
                .create();
        Set<String> nameSet = new Set<String>{
                'Czech Republic',
                'CZ',
                'CZE'
        };

        //When
        Test.startTest();
            List<Lead> foundLeads = new LeadSelector().selectByCountryNames(nameSet);
        Test.stopTest();

        //Then
        System.assertEquals(1,foundLeads.size(),'Unexpected number of records found');
    }
}