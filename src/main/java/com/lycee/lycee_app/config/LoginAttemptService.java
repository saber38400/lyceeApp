package com.lycee.lycee_app.config;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import org.springframework.stereotype.Component;

@Component
public class LoginAttemptService {

    private static final int MAX_ATTEMPTS = 5;
    private static final long LOCK_DURATION_MS = 5 * 60 * 1000;

    private final Map<String, Integer> attempts = new ConcurrentHashMap<>();
    private final Map<String, Long> lockTime = new ConcurrentHashMap<>();

    public boolean isLocked(String email) {

        Long lockedAt = lockTime.get(email);

        if(lockedAt == null) {
            return false;
        }

        if(System.currentTimeMillis() - lockedAt > LOCK_DURATION_MS) {
            lockTime.remove(email);
            attempts.remove(email);
            return false;
        }

        return true;

    }

    public void loginFailed(String email) {

        int current = attempts.getOrDefault(email, 0) + 1;

        attempts.put(email, current);

        if(current >= MAX_ATTEMPTS) {
            lockTime.put(email, System.currentTimeMillis());
        }

    }

    public void loginSucceeded(String email) {
        attempts.remove(email);
        lockTime.remove(email);
    }

    public long getRemainingLockSeconds(String email) {

        Long lockedAt = lockTime.get(email);

        if(lockedAt == null) {
            return 0;
        }

        long elapsed = System.currentTimeMillis() - lockedAt;
        long remaining = (LOCK_DURATION_MS - elapsed) / 1000;

        return Math.max(remaining, 0);

    }

}