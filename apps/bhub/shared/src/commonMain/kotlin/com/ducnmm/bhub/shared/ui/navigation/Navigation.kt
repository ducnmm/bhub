package com.ducnmm.bhub.shared.ui.navigation

import androidx.compose.runtime.Composable
import androidx.compose.runtime.remember
import androidx.compose.runtime.mutableStateOf

enum class Screen {
    Home,
    BHubList,
    CreateBHub,
    BHubDetails
}

class Navigator {
    private val _currentScreen = mutableStateOf<Screen>(Screen.Home)
    val currentScreen: Screen get() = _currentScreen.value

    fun navigateTo(screen: Screen) {
        _currentScreen.value = screen
    }

    fun navigateBack() {
        when (currentScreen) {
            Screen.BHubList -> navigateTo(Screen.Home)
            Screen.CreateBHub -> navigateTo(Screen.BHubList)
            Screen.BHubDetails -> navigateTo(Screen.BHubList)
            Screen.Home -> {} // Do nothing when on home screen
        }
    }
}

@Composable
fun rememberNavigator(): Navigator {
    return remember { Navigator() }
}

@Composable
fun Navigation(navigator: Navigator) {
    when (navigator.currentScreen) {
        Screen.Home -> HomeScreen(onExploreClick = { navigator.navigateTo(Screen.BHubList) })
        Screen.BHubList -> BHubListScreen(
            onCreateClick = { navigator.navigateTo(Screen.CreateBHub) },
            onBHubClick = { navigator.navigateTo(Screen.BHubDetails) }
        )
        Screen.CreateBHub -> CreateBHubScreen(
            onBackClick = { navigator.navigateBack() },
            onCreateSuccess = { navigator.navigateBack() }
        )
        Screen.BHubDetails -> {} // TODO: Implement BHub details screen
    }
}