// This is a basic Flutter widget test for the volleyball rotation app.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:volley_rotation/main.dart';
import 'package:volley_rotation/team_state.dart';

void main() {
  testWidgets('Volleyball app basic functionality test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the app loads with the main menu
    expect(find.text('Base rotation'), findsOneWidget);
    
    // Verify that we can find volleyball-related elements
    expect(find.text('OH'), findsWidgets); // Outside Hitter position
    expect(find.text('MB'), findsOneWidget); // Middle Blocker position
    expect(find.text('S'), findsOneWidget); // Setter position
    
    // Verify default player numbers are displayed
    expect(find.text('1'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
    expect(find.text('4'), findsOneWidget);
    expect(find.text('5'), findsOneWidget);
    expect(find.text('6'), findsOneWidget);
    expect(find.text('L'), findsOneWidget); // Libero
  });

  testWidgets('Team state management test', (WidgetTester tester) async {
    // Test the team state directly
    final teamState = TeamState();
    
    // Test initial values
    expect(teamState.getHomePlayer('pos1'), '1');
    expect(teamState.getHomePlayer('pos2'), '2');
    expect(teamState.getHomePlayer('libero'), 'L');
    
    // Test updating a player
    teamState.updateHomePlayer('pos1', '10');
    expect(teamState.getHomePlayer('pos1'), '10');
    
    // Test opponent team
    expect(teamState.getOpponentPlayer('pos1'), '1');
    teamState.updateOpponentPlayer('pos1', '15');
    expect(teamState.getOpponentPlayer('pos1'), '15');
    
    // Verify teams are independent
    expect(teamState.getHomePlayer('pos1'), '10');
    expect(teamState.getOpponentPlayer('pos1'), '15');
  });

  testWidgets('Menu navigation test', (WidgetTester tester) async {
    // Build our app
    await tester.pumpWidget(const MyApp());
    
    // Find and tap on opponent rotation
    final opponentTab = find.text('Base rotation opponent');
    expect(opponentTab, findsOneWidget);
    
    await tester.tap(opponentTab);
    await tester.pump();
    
    // Verify we're now on the opponent screen
    expect(find.text('Base rotation opponent'), findsOneWidget);
  });

  testWidgets('Responsive layout test', (WidgetTester tester) async {
    // Test with small screen size (mobile)
    await tester.binding.setSurfaceSize(const Size(400, 800));
    await tester.pumpWidget(const MyApp());
    
    // Verify the app loads and handles small screen
    expect(find.byType(SingleChildScrollView), findsWidgets);
    
    // Test with large screen size (tablet)
    await tester.binding.setSurfaceSize(const Size(800, 600));
    await tester.pumpWidget(const MyApp());
    await tester.pump();
    
    // Verify tablet layout
    expect(find.text('Menu'), findsOneWidget);
    
    // Reset surface size
    addTearDown(() => tester.binding.setSurfaceSize(null));
  });
}