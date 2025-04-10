package com.example.spring_kotlin

import org.springframework.stereotype.Service

@Service
class AuthServiceEager {
    private val validUser = "admin"
    private val validPassword = "admin"

    init {
        println("AuthServiceEager init")
    }

    fun authorize(username: String, password: String): Boolean {
        return username == validUser && password == validPassword
    }
}
