/**
 * Created by david on 05.09.2023.
 */

public with sharing class LeadSelector {
    public List<Lead> selectByCountryNames(Set<String> values){
        return [
                SELECT Country,alpha2Code__c,alpha3Code__c,capital__c,Region__c,Regional_Blocs__c
                FROM Lead
                WHERE Country IN :values
        ];
    }
}