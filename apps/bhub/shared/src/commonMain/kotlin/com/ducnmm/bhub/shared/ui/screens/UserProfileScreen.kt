package com.ducnmm.bhub.shared.ui.screens

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun UserProfileScreen(
    onBackClick: () -> Unit,
    onEditProfile: () -> Unit,
    onPaymentHistoryClick: () -> Unit,
    onSettingsClick: () -> Unit,
    onBHubClick: (String) -> Unit
) {
    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("Profile") },
                navigationIcon = {
                    IconButton(onClick = onBackClick) {
                        Icon(Icons.Default.ArrowBack, contentDescription = "Back")
                    }
                },
                actions = {
                    IconButton(onClick = onSettingsClick) {
                        Icon(Icons.Default.Settings, contentDescription = "Settings")
                    }
                }
            )
        }
    ) { padding ->
        LazyColumn(
            modifier = Modifier
                .fillMaxSize()
                .padding(padding)
        ) {
            item { UserHeader(onEditProfile = onEditProfile) }
            item { Divider(modifier = Modifier.padding(vertical = 16.dp)) }
            item { UserActions(onPaymentHistoryClick = onPaymentHistoryClick) }
            item { 
                Text(
                    text = "Joined BHubs",
                    style = MaterialTheme.typography.titleLarge,
                    modifier = Modifier.padding(16.dp)
                )
            }
            items(sampleJoinedBHubs) { bhub ->
                JoinedBHubItem(bhub = bhub, onClick = { onBHubClick(bhub.id) })
            }
        }
    }
}

@Composable
private fun UserHeader(
    onEditProfile: () -> Unit
) {
    Column(
        modifier = Modifier
            .fillMaxWidth()
            .padding(16.dp),
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Icon(
            imageVector = Icons.Default.AccountCircle,
            contentDescription = null,
            modifier = Modifier.size(96.dp),
            tint = MaterialTheme.colorScheme.primary
        )
        Spacer(modifier = Modifier.height(16.dp))
        Text(
            text = "John Doe",
            style = MaterialTheme.typography.headlineMedium
        )
        Text(
            text = "john.doe@example.com",
            style = MaterialTheme.typography.bodyLarge,
            color = MaterialTheme.colorScheme.onSurfaceVariant
        )
        Spacer(modifier = Modifier.height(16.dp))
        OutlinedButton(
            onClick = onEditProfile,
            colors = ButtonDefaults.outlinedButtonColors(
                contentColor = MaterialTheme.colorScheme.primary
            )
        ) {
            Text("Edit Profile")
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
private fun UserActions(
    onPaymentHistoryClick: () -> Unit
) {
    Column(
        modifier = Modifier.fillMaxWidth()
    ) {
        ListItem(
            headlineContent = { Text("Payment History") },
            leadingContent = {
                Icon(
                    Icons.Default.Payment,
                    contentDescription = null,
                    tint = MaterialTheme.colorScheme.primary
                )
            },
            trailingContent = {
                Icon(
                    Icons.Default.ChevronRight,
                    contentDescription = null
                )
            },
            modifier = Modifier.clickable(onClick = onPaymentHistoryClick)
        )
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
private fun JoinedBHubItem(
    bhub: JoinedBHub,
    onClick: () -> Unit
) {
    Card(
        modifier = Modifier
            .fillMaxWidth()
            .padding(horizontal = 16.dp, vertical = 8.dp),
        onClick = onClick
    ) {
        ListItem(
            headlineContent = { Text(bhub.name) },
            supportingContent = { Text(bhub.role) },
            leadingContent = {
                Icon(
                    Icons.Default.Group,
                    contentDescription = null,
                    tint = MaterialTheme.colorScheme.primary
                )
            }
        )
    }
}

data class JoinedBHub(
    val id: String,
    val name: String,
    val role: String
)

private val sampleJoinedBHubs = listOf(
    JoinedBHub("1", "Tech Enthusiasts", "Member"),
    JoinedBHub("2", "Digital Artists", "Admin"),
    JoinedBHub("3", "Startup Network", "Moderator")
)