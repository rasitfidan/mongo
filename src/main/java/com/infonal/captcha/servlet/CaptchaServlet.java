/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package com.infonal.captcha.servlet;

import com.infonal.captcha.Captcha;
import com.infonal.captcha.CaptchaProducer;
import java.io.IOException;
import java.io.OutputStream;
import javax.imageio.ImageIO;
import javax.servlet.ServletException;
import javax.servlet.http.*;

/**
 *
 * @author fidanras
 */
public class CaptchaServlet extends HttpServlet {
    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response)
                throws ServletException, IOException {
          //gif tipi
          response.setContentType("image/gif");
          
          OutputStream out = response.getOutputStream();
          
          Captcha captcha = CaptchaProducer.produce(100, 50, 6);
          
          HttpSession session = request.getSession();
          
          //Karsilastirmak uzere session 'a ekleniyor
          session.setAttribute("captcha", captcha.getCaptchaString());
          
          ImageIO.write(captcha.getCaptchaImage(), "gif",out);
          
          out.close();System.out.println("ok...captcha");
      }
    
}
