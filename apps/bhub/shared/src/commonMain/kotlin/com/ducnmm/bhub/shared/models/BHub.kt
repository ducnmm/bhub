package com.ducnmm.bhub.shared.models

data class BHub(
    val id: String,
    val name: String,
    val description: String,
    val memberCount: Int
)

data class Member(
    val id: String,
    val name: String,
    val role: String
)