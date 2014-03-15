/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package com.infonal.dao.user;

import com.infonal.model.user.User;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.mongodb.core.MongoOperations;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.stereotype.Repository;

/**
 *
 * @author fidanras
 */
@Repository
public class UserDao {
    @Autowired
    MongoOperations mongoOperations;
    
    public void createUser(User user){
        checkDB();

        mongoOperations.insert(user);
        
    }

    public void updateUser(User user){
        checkDB();
        mongoOperations.save(user);
    }
    
    public void updateUser(String uid,String name,String surname,String telNo){
        User user = new User();
        
        user.setId(uid);
	
        user.setName(name);

        user.setSurname(surname);

        user.setTelNo(telNo);
 
        updateUser(user);
    }
    
    
    public User findUserById(String id){
        checkDB();

        User result = mongoOperations.findById(id, User.class);
        
        return result;
    }
    
    public List<User> findAllUsers(){
        checkDB();

        List<User> results = mongoOperations.findAll(User.class);
        
        return results;
    }
    
    public void deleteUser(User user){
        checkDB();
        mongoOperations.remove(user);
        
    }
    
    public void deleteUserById(String id){
        User user = this.findUserById(id);
        
        deleteUser(user);
        
    }
    private void checkDB() {
        if (!mongoOperations.collectionExists(User.class)) {
            mongoOperations.createCollection(User.class);
        }
    }
}
