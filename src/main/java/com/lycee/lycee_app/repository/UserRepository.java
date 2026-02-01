package com.lycee.lycee_app.repository;

import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import com.lycee.lycee_app.model.User;

public interface UserRepository extends JpaRepository<User, Integer> {
	
	@Query("from User where user_email=?1")
	public List<User> findByEMAIL(String email);
	
	@Query("from User where user_email=?1 and user_pass=?2")
	public User findByUsernamePassword(String username,String password);

}