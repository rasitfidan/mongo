/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package com.infonal.captcha;

/**
 *
 * @author fidanras
 */
import java.awt.image.BufferedImage;

public class Captcha {
	public final static String AVAILABLES = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	
	private String captchaString;
	private BufferedImage captchaImage;
	
	public String getCaptchaString() {
		return captchaString;
	}
	public void setCaptchaString(String captchaString) {
		this.captchaString = captchaString;
	}
	public BufferedImage getCaptchaImage() {
		return captchaImage;
	}
	public void setCaptchaImage(BufferedImage captchaImage) {
		this.captchaImage = captchaImage;
	}
	
}
