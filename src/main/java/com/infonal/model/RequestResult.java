/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package com.infonal.model;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 *
 * @author fidanras
 */
public class RequestResult implements JSONObject{
    private boolean successfull = false;
    
    private final Map<String,String> messages;
    
    private List< ? extends JSONObject> resultList; 

    public RequestResult() {
        this.messages = new HashMap<String,String>();
        this.resultList = new ArrayList<JSONObject>();
    }

    public boolean isSuccessfull() {
        return successfull;
    }

    public void setSuccessfull(boolean successfull) {
        this.successfull = successfull;
    }

    public void addMessage(String key,String value) {
        messages.put(key, value);
    }

    public Map<String,String> getMessages(){
        return messages;
    }
            
    public List<? extends JSONObject> getResultList() {
        return resultList;
    }
    
    public void setResultList(List< ? extends JSONObject> resultList) {
        this.resultList = resultList;
    }
    
    /**
     * Third party json marshaller kullanilabilir.
     * @return 
     */
    @Override
    public String toJSONString(){
        StringBuilder JSONBuilder = new StringBuilder();
        
        JSONBuilder.append("{");
        JSONBuilder.append("\"successfull\"");
        JSONBuilder.append(":");
        JSONBuilder.append(this.isSuccessfull());
        JSONBuilder.append(",");
        
        //append messages through loop
        JSONBuilder.append("\"messages\"");
        JSONBuilder.append(":");
        JSONBuilder.append("[");
        
        for(String messageKey : getMessages().keySet()){  
            String messageValue = getMessages().get(messageKey);
            
            JSONBuilder.append("{");
            JSONBuilder.append("\"");
            JSONBuilder.append(messageKey);
            JSONBuilder.append("\"");
            JSONBuilder.append(":");
            JSONBuilder.append("\"");
            JSONBuilder.append(messageValue);
            JSONBuilder.append("\"");
            JSONBuilder.append("}");
            
            JSONBuilder.append(",");
        }
        //the last comma has to be deleted
        if(JSONBuilder.toString().endsWith(",")){
            JSONBuilder.deleteCharAt(JSONBuilder.length()-1);
        }
        JSONBuilder.append("]");
        //end of messages
        
        JSONBuilder.append(",");
        
        //result list , if there are any list outcomes
        JSONBuilder.append("\"resultList\"");
        JSONBuilder.append(":");
        JSONBuilder.append("[");
        
        for(JSONObject jSONObject : getResultList()){
            JSONBuilder.append(jSONObject.toJSONString());
            JSONBuilder.append(",");
        }
        
        if(JSONBuilder.toString().endsWith(",")){
            JSONBuilder.deleteCharAt(JSONBuilder.length()-1);
        }
        //end of resultlist append
        JSONBuilder.append("]");
        JSONBuilder.append("}");
        
        return JSONBuilder.toString();
    }
}
