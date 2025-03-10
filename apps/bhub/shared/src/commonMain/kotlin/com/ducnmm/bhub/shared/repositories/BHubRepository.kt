package com.ducnmm.bhub.shared.repositories

import com.ducnmm.bhub.shared.models.BHub
import com.ducnmm.bhub.shared.network.BHubApiClient
import kotlinx.serialization.json.Json

class BHubRepository(private val apiClient: BHubApiClient) {
    private val json = Json { ignoreUnknownKeys = true }

    suspend fun getBHubs(): List<BHub> {
        val response = apiClient.getBHubs()
        return json.decodeFromString(response)
    }

    suspend fun getBHubById(id: String): BHub {
        val response = apiClient.getBHubById(id)
        return json.decodeFromString(response)
    }

    suspend fun createBHub(name: String, description: String): BHub {
        val response = apiClient.createBHub(name, description)
        return json.decodeFromString(response)
    }

    suspend fun joinBHub(bhubId: String, userId: String): Boolean {
        return try {
            apiClient.joinBHub(bhubId, userId)
            true
        } catch (e: Exception) {
            false
        }
    }
}