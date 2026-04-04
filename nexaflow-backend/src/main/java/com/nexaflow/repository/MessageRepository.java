package com.nexaflow.repository;

import com.nexaflow.entity.Message;
import com.nexaflow.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface MessageRepository extends JpaRepository<Message, String> {
    
    List<Message> findByToUser(User toUser);
    
    List<Message> findByToUserOrderByCreatedAtDesc(User toUser);
    
    List<Message> findByFromUser(User fromUser);
    
    List<Message> findByFromUserOrderByCreatedAtDesc(User fromUser);
    
    List<Message> findByToUserAndIsReadFalse(User toUser);
    
    long countByToUserAndIsReadFalse(User toUser);
}
