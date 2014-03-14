/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package com.infonal.model.test;

import com.infonal.model.JSONObject;
import com.infonal.model.RequestResult;
import com.infonal.model.user.User;
import java.util.ArrayList;
import java.util.List;
import org.junit.After;
import org.junit.AfterClass;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;
import static org.junit.Assert.*;

/**
 *
 * @author fidanras
 */
public class JSonJUnitTest {
    
    public JSonJUnitTest() {
    }
    
    @BeforeClass
    public static void setUpClass() {
    }
    
    @AfterClass
    public static void tearDownClass() {
    }
    
    @Before
    public void setUp() {
    }
    
    @After
    public void tearDown() {
    }

    // TODO add test methods here.
    // The methods must be annotated with annotation @Test. For example:
    //
    // @Test
    // public void hello() {}
    
    @Test
    public void testJSONObject(){
        RequestResult rr = new RequestResult();
        
        rr.setSuccessfull(false);
        
        rr.addMessage("Hata"," mongo DB Down");
        
        List <JSONObject> users = new ArrayList <JSONObject>();
        
        User u = new User();
        
        u.setId("1");
        
        u.setName("Rasit");
        
        u.setSurname("Fidan");
        
        u.setTelNo("210234455");
        
        users.add(u);
        
        rr.setResultList(users);
        
        System.out.println(rr.toJSONString());
    }
}
