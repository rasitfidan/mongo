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
import java.awt.Color;
import java.awt.Font;
import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.util.Random;

public class CaptchaProducer {
	public static Captcha produce(int imageWidth , int imageHeight, int captchaLength) {
		Captcha captcha = new Captcha();
		
		BufferedImage captchaImage = new BufferedImage(imageWidth,imageHeight,BufferedImage.TYPE_4BYTE_ABGR);
		
		StringBuilder captchaBuilder = new StringBuilder();
		
		for(int i=0 ; i<captchaLength ; i++) {
			Random rnd = new Random();
			int r = rnd.nextInt(Captcha.AVAILABLES.length());
			
			char mC = Captcha.AVAILABLES.charAt(r);
			
			//Add to Builder
			captchaBuilder.append(mC);				
		}
		
		//Add to image
		Graphics2D g = (Graphics2D) captchaImage.getGraphics();
		
		g.setColor(Color.BLACK);	
		g.fillRect(0, 0, imageWidth, imageHeight);
		
		g.setColor(Color.WHITE);	
		
                //Resmi karistir ki image processorlarin cozmesi mumkun olmasin
		//Capraz cizgiler
                g.drawLine(0, 0, imageWidth, imageHeight);
		
		g.drawLine(0, imageHeight, imageWidth, 0);
		
                //Dikey cizgiler
                g.drawLine(imageWidth/4, 0, imageWidth/4, imageHeight);
                
                g.drawLine(2* imageWidth/4, 0, 2* imageWidth/4, imageHeight);
                
                g.drawLine(3* imageWidth/4, 0, 3* imageWidth/4, imageHeight);
                
		Font font = new Font("Verdana", Font.BOLD, 15);
		
		g.setFont(font);
		
                //FontMetrics ile ortalanabilir fakat hardcode gecildi.
		g.drawString(captchaBuilder.toString(), 15, 30);
		
		captcha.setCaptchaImage(captchaImage);
		captcha.setCaptchaString(captchaBuilder.toString());
		
		return captcha;
		
	}
}

