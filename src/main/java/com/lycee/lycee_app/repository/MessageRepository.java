package com.lycee.lycee_app.repository;

import com.lycee.lycee_app.model.Message;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface MessageRepository
        extends JpaRepository<Message, Integer> {

    List<Message> findByReceiver(String receiver);

    long countByReceiverAndReadMessageFalse(String receiver);

    @Query("""
            SELECT m
            FROM Message m
            WHERE
                (m.sender = ?1 AND m.receiver = ?2)
                OR
                (m.sender = ?2 AND m.receiver = ?1)
            ORDER BY m.sendDate
            """)
    List<Message> getConversation(String user1, String user2);
}