public with sharing class ShippingCostProvider {
    @InvocableMethod(label='Shipping Cost Estimate' description='Check the estimated shipping cost for a reseller order Order__c')
    public static List<ShippingEstimateResponse> getShippingCostEstimate(List<ShippingEstimateRequest> requests) {
       // Retrieve the order for which we want to check the shipping cost estimate
       String orderNumberToCheck = (String) requests[0].orderNumber;
       String orderId = (String) requests[0].orderId;
 
       //Business Logic - Make a HTTP callout to get shipping cost estimate 
       HttpRequest req = new HttpRequest();
       req.setEndpoint('callout:Workshop_API/api/getShippingEstimate?orderId='+orderId);
       req.setMethod('GET');
       Http http = new Http();
       HttpResponse res = http.send(req);  
 
       // Create the response for Copilot
       if(res.getStatusCode() == 200){
          ShippingEstimateResponse responseData = (ShippingEstimateResponse)JSON.deserialize(res.getBody(),ShippingEstimateResponse.class);
          responseData.estimatedCostDescription = 'The estimated shipping cost for the order ' + orderNumberToCheck + ' is ' + responseData.estimatedCost + ' dollars.';
          return new List<ShippingEstimateResponse> { responseData };
       }
       return null;
    }
 
    public class ShippingEstimateRequest {
       @InvocableVariable(required=true description='Order Number for which shipping estimate is requested. Use the Name field of a Order__c record.')
       public String orderNumber;
       
       @InvocableVariable(required=true description='18 digit Salesforce ID for a reseller order Order__c. Fire the QueryRecords action before this to identify the Order__c record.')
       public Id orderId;
    }
 
    public class ShippingEstimateResponse {
       @InvocableVariable(description='Success or failure status response from the Shipping Cost Estimate Integration')
       public String status;
 
       @InvocableVariable(description='The estimated shipping cost returned by the Shipping Cost Estimate Integration')
       public Integer estimatedCost; 
 
       @InvocableVariable(description='The estimated shipping cost for the order')
       public String estimatedCostDescription;              
    }
 }