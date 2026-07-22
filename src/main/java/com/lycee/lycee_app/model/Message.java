package com.lycee.lycee_app.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@Entity
@Table(name = "messages")
public class Message {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    private String sender;

    private String receiver;

    @Column(length = 5000)
    private String content;

    private boolean readMessage = false;

    private LocalDateTime sendDate = LocalDateTime.now();

    public Integer getId() {
        return id;
    }

    public String getSender() {
        return sender;
    }

    public void setSender(String sender) {
        this.sender = sender;
    }

    public String getReceiver() {
        return receiver;
    }

    public void setReceiver(String receiver) {
        this.receiver = receiver;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public boolean isReadMessage() {
        return readMessage;
    }

    public void setReadMessage(boolean readMessage) {
        this.readMessage = readMessage;
    }

    public LocalDateTime getSendDate() {
        return sendDate;
    }

    public String getFormattedSendDate() {
        return sendDate.format(
            DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")
        );
    }
}