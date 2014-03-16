/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package com.infonal.controller;

/**
 *
 * @author fidanras
 */
import com.infonal.dao.user.UserDao;
import com.infonal.model.RequestResult;
import com.infonal.model.user.User;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;  
import org.springframework.web.bind.annotation.RequestMapping;  
import org.springframework.web.servlet.ModelAndView;  
  
@Controller  
public class UserController {  
    private static final String JSON = "JSONText";

        @Autowired
        private UserDao userDao;
        
	@RequestMapping("/user/create")
	public ModelAndView create(HttpServletRequest request,
		HttpServletResponse response) {
            RequestResult result = new RequestResult();
            
            String name = request.getParameter("name");
            String surname = request.getParameter("surname");
            String telNo = request.getParameter("telNo");
            String captchaParam = request.getParameter("captcha");
            
            //session'da tutulan captcha'yi al
            HttpSession session = request.getSession();
            
            String captchaValue = (String) session.getAttribute("captcha");
            
            //captcha karsilastirma
            if(captchaParam.equals(captchaValue)){
                User user = new User(name,surname,telNo);
                try{
                    userDao.createUser(user);
                    result.setSuccessfull(true);
                    result.addMessage("SUCCESS", "Sonuc basarili");
                }catch(Exception e){
                    result.setSuccessfull(false);
                    result.addMessage("ERROR", "Hata : "+e.getMessage());
                }
            } else {
                result.setSuccessfull(false);
                result.addMessage("ERROR", "Captcha Dogrulanamadi. Tekrar Deneyiniz.");
            }
            
            ModelAndView modelAndView = new ModelAndView("ajax/AjaxResult");
            
            modelAndView.addObject(UserController.JSON, result.toJSONString());
            
            return modelAndView;
 
	}
 	@RequestMapping("/user/update")
	public ModelAndView update(HttpServletRequest request,
		HttpServletResponse response) {
 
            RequestResult result = new RequestResult();
            
            String userid = request.getParameter("userid");
            String name = request.getParameter("name");
            String surname = request.getParameter("surname");
            String telNo = request.getParameter("telNo");
            
            try{
                userDao.updateUser(userid, name, surname, telNo);
                result.setSuccessfull(true);
                result.addMessage("SUCCESS", "Sonuc basarili");
            }catch(Exception e){
                result.setSuccessfull(false);
                result.addMessage("ERROR", "Hata : "+e.getMessage());
            }
            
            ModelAndView modelAndView = new ModelAndView("ajax/AjaxResult");
            
            modelAndView.addObject(UserController.JSON, result.toJSONString());
            
            return modelAndView;
	}
 
	@RequestMapping("/user/delete")
	public ModelAndView delete(HttpServletRequest request,
		HttpServletResponse response) {
            RequestResult result = new RequestResult();
            String userid = request.getParameter("userid");
            
            try{
                userDao.deleteUserById(userid);
                result.setSuccessfull(true);
                result.addMessage("SUCCESS", "Sonuc basarili");
            }catch(Exception e){
                result.setSuccessfull(false);
                result.addMessage("ERROR", "Hata : "+e.getMessage());
            }

            ModelAndView modelAndView = new ModelAndView("ajax/AjaxResult");
            
            modelAndView.addObject(UserController.JSON, result.toJSONString());
            return modelAndView;
	}
 
	@RequestMapping("/user/list")
	public ModelAndView list(HttpServletRequest request,
		HttpServletResponse response) {
            
            RequestResult result = new RequestResult();
            try{
                List <User> list = userDao.findAllUsers();
            
                result.setResultList(list);
            
                result.setSuccessfull(true);
                result.addMessage("SUCCESS", "Sonuc basarili");
            }catch(Exception e){
                result.setSuccessfull(false);
                result.addMessage("ERROR", "Hata : "+e.getMessage());
            }
            
            ModelAndView modelAndView = new ModelAndView("ajax/AjaxResult");
            
            modelAndView.addObject(UserController.JSON, result.toJSONString());
            
            return modelAndView;
 
	}
        
        @RequestMapping("/UserPage")
	public ModelAndView redirectToUserPage() { 
		return new ModelAndView("user/UserPage");
 
	}
}  