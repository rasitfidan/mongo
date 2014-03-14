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
    private void checkDB() {
        if (!mongoOperations.collectionExists(User.class)) {
            mongoOperations.createCollection(User.class);
        }
    }
}
