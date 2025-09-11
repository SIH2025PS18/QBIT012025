// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'dart:io';

// Future<void> deployUserProfilesTable() async {
//   try {
//     // Read the SQL file
//     final sqlFile = File('sql/create_user_profiles_table.sql');
//     final sqlContent = await sqlFile.readAsString();

//     // Execute the SQL
//     final client = Supabase.instance.client;
//     await client.rpc('execute_sql', params: {'sql': sqlContent});

//     print('✅ User profiles table created successfully!');
//   } catch (e) {
//     print('❌ Error creating user profiles table: $e');

//     // Try alternative approach - execute statements individually
//     try {
//       final client = Supabase.instance.client;

//       // Create table
//       await client.from('user_profiles').select().limit(1);
//       print('✅ Table already exists or created successfully');
//     } catch (e2) {
//       print('❌ Alternative approach failed: $e2');
//       print('Please run the SQL manually in Supabase SQL Editor:');
//       print('https://supabase.com/dashboard/project/szrxgxvypusvkkyykrjz/sql');
//     }
//   }
// }

// void main() async {
//   await deployUserProfilesTable();
// }
