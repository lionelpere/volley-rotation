import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'rotation_model.dart';

class PersistenceService {
  static const String _rotationManagerKey = 'rotation_manager';
  static const String _homeTeamKey = 'home_team';
  static const String _opponentTeamKey = 'opponent_team';
  
  static Future<void> saveRotationManager(RotationManager manager) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(manager.toJson());
    await prefs.setString(_rotationManagerKey, jsonString);
  }
  
  static Future<RotationManager?> loadRotationManager() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_rotationManagerKey);
    
    if (jsonString == null) return null;
    
    try {
      final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
      return RotationManager.fromJson(jsonMap);
    } catch (e) {
      return null;
    }
  }
  
  static Future<void> saveTeamRotation(TeamRotation team, {required bool isHomeTeam}) async {
    final prefs = await SharedPreferences.getInstance();
    final key = isHomeTeam ? _homeTeamKey : _opponentTeamKey;
    final jsonString = json.encode(team.toJson());
    await prefs.setString(key, jsonString);
  }
  
  static Future<TeamRotation?> loadTeamRotation({required bool isHomeTeam}) async {
    final prefs = await SharedPreferences.getInstance();
    final key = isHomeTeam ? _homeTeamKey : _opponentTeamKey;
    final jsonString = prefs.getString(key);
    
    if (jsonString == null) return null;
    
    try {
      final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
      return TeamRotation.fromJson(jsonMap);
    } catch (e) {
      return null;
    }
  }
  
  static Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_rotationManagerKey);
    await prefs.remove(_homeTeamKey);
    await prefs.remove(_opponentTeamKey);
  }
  
  static Future<bool> hasStoredData() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_rotationManagerKey) ||
           prefs.containsKey(_homeTeamKey) ||
           prefs.containsKey(_opponentTeamKey);
  }
}