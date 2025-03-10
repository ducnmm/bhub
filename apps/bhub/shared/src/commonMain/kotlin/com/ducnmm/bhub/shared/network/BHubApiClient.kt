package com.ducnmm.bhub.shared.network

import io.ktor.client.*
import io.ktor.client.request.*
import io.ktor.client.statement.*
import io.ktor.http.*

class BHubApiClient(private val client: HttpClient) {
    private val baseUrl = "http://localhost:8080/api"

    suspend fun getBHubs(): String {
        return client.get("$baseUrl/bhubs").bodyAsText()
    }

    suspend fun getBHubById(id: String): String {
        return client.get("$baseUrl/bhubs/$id").bodyAsText()
    }

    suspend fun createBHub(name: String, description: String): String {
        return client.post("$baseUrl/bhubs") {
            contentType(ContentType.Application.Json)
            setBody(mapOf(
                "name" to name,
                "description" to description
            ))
        }.bodyAsText()
    }

    suspend fun joinBHub(bhubId: String, userId: String): String {
        return client.post("$baseUrl/bhubs/$bhubId/members") {
            contentType(ContentType.Application.Json)
            setBody(mapOf("userId" to userId))
        }.bodyAsText()
    }
}