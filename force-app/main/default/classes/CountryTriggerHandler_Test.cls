/**
 * Created by david on 05.09.2023.
 */
@IsTest
private class CountryTriggerHandler_Test {
    @IsTest
    private static void updateRelatedLeadsTest(){
        //Given
        Country__c czechCountry = (Country__c) new SObjectBuilder(Country__c.SObjectType)
                .put(Country__c.Name, 'Czech Republic')
                .put(Country__c.alpha2Code__c, 'CZ')
                .put(Country__c.alpha3Code__c, 'CZE')
                .put(Country__c.capital__c, 'Prague')
                .put(Country__c.Region__c, 'Europe')
                .build().getRecord();

        Lead relatedLead = (Lead)new SObjectBuilder(Lead.SObjectType)
                .put(Lead.LastName,'Test')
                .put(Lead.Company,'Test')
                .put(Lead.Status,'Open - Not Contacted')
                .put(Lead.Country,'CZE')
                .create().getRecord();

        //Mocks
        GenericStub stub = new GenericStub();
        stub = stub.forMethod('selectByCountryNames')
                .thatReturns(new List<Lead>{relatedLead});

        LeadSelector selectorMock = (LeadSelector) Test.createStub(LeadSelector.class, stub);
        CountryTriggerHandler handler = new CountryTriggerHandler();
        handler.leadSelectorImpl = selectorMock;

        //When
        Test.startTest();
            handler.updateRelatedLeads(new List<Country__c>{czechCountry});
        Test.stopTest();

        //Then
        Lead modifiedRecord = [SELECT alpha3Code__c FROM Lead WHERE Id = :relatedLead.Id];
        System.assertEquals(czechCountry.alpha3Code__c, modifiedRecord.alpha3Code__c,'Change didn\'t happen');
    }
}