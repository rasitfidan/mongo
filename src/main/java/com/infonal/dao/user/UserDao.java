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
    
    public boolean createUser(User user){
        checkDB();

        mongoOperations.insert(user);
        
        return true;
        
    }

    public boolean updateUser(String uid,String name,String surname,String telNo){
        Query query = new Query();
	
        query.addCriteria(Criteria.where("id").is(uid));
	query.fields().include("id");
        
        User user = mongoOperations.findOne(query, User.class);
	
        user.setName(name);

        user.setSurname(surname);

        user.setTelNo(telNo);
 
        mongoOperations.save(user);
        
        return true;
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
    
    public boolean deleteUser(User user){
        mongoOperations.remove(user);
        
        return true;
        
    }
    
    public boolean deleteUserById(String id){
        User user = this.findUserById(id);
        
        deleteUser(user);
        
        return true;
        
    }
    private void checkDB() {
        if (!mongoOperations.collectionExists(User.class)) {
            mongoOperations.createCollection(User.class);
        }
    }
}
