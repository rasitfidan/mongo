/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package com.infonal.model.user;

import com.infonal.model.JSONObject;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
/**
 *
 * @author fidanras
 */
@Document
public class User implements JSONObject{
    @Id
    private String id;
    private String name;
    private String surname;
    private String telNo;
    
    public User(){}
    
    public User(String name,String surname,String telNo){
        this.name=name;
        this.surname=surname;
        this.telNo=telNo;
    }
    
    public String getId() {
        return id;
    }
 
    public void setId(String id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getSurname() {
        return surname;
    }

    public void setSurname(String surname) {
        this.surname = surname;
    }

    public String getTelNo() {
        return telNo;
    }

    public void setTelNo(String telNo) {
        this.telNo = telNo;
    }

    @Override
    public String toJSONString() {
        StringBuilder JSONBuilder = new StringBuilder();
        
        JSONBuilder.append("{");
        JSONBuilder.append("\"id\"");
        JSONBuilder.append(":");
        JSONBuilder.append("\"");
        JSONBuilder.append(this.getId());
        JSONBuilder.append("\"");
        JSONBuilder.append(",");
                
        JSONBuilder.append("\"name\"");
        JSONBuilder.append(":");
        JSONBuilder.append("\"");
        JSONBuilder.append(this.getName());
        JSONBuilder.append("\"");
        JSONBuilder.append(",");
        
        JSONBuilder.append("\"surname\"");
        JSONBuilder.append(":");
        JSONBuilder.append("\"");
        JSONBuilder.append(this.getSurname());
        JSONBuilder.append("\"");
        JSONBuilder.append(",");
        
        JSONBuilder.append("\"telNo\"");
        JSONBuilder.append(":");
        JSONBuilder.append("\"");
        JSONBuilder.append(this.getTelNo());
        JSONBuilder.append("\"");
        JSONBuilder.append("}");
        
        return JSONBuilder.toString();
    }
    
}
