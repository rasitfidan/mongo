/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package com.infonal.model.test;

import com.infonal.captcha.Captcha;
import com.infonal.captcha.CaptchaProducer;
import java.io.FileOutputStream;
import java.io.IOException;
import javax.imageio.ImageIO;
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
public class CaptchaJUnitTest {
    
    public CaptchaJUnitTest() {
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
    public void testCatcha() throws IOException{
            Captcha c = CaptchaProducer.produce(100, 50, 6);

            ImageIO.write(c.getCaptchaImage(), "gif", new FileOutputStream("D:\\test.gif"));

            System.out.println("Captcha--"+c.getCaptchaString());
    }
}
