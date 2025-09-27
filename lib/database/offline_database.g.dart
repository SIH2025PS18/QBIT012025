// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offline_database.dart';

// ignore_for_file: type=lint
class $PatientProfilesTable extends PatientProfiles
    with TableInfo<$PatientProfilesTable, PatientProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PatientProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ageMeta = const VerificationMeta('age');
  @override
  late final GeneratedColumn<String> age = GeneratedColumn<String>(
    'age',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _genderMeta = const VerificationMeta('gender');
  @override
  late final GeneratedColumn<String> gender = GeneratedColumn<String>(
    'gender',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _medicalHistoryMeta = const VerificationMeta(
    'medicalHistory',
  );
  @override
  late final GeneratedColumn<String> medicalHistory = GeneratedColumn<String>(
    'medical_history',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _profileImageMeta = const VerificationMeta(
    'profileImage',
  );
  @override
  late final GeneratedColumn<String> profileImage = GeneratedColumn<String>(
    'profile_image',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isOnlineMeta = const VerificationMeta(
    'isOnline',
  );
  @override
  late final GeneratedColumn<bool> isOnline = GeneratedColumn<bool>(
    'is_online',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_online" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _lastSyncedMeta = const VerificationMeta(
    'lastSynced',
  );
  @override
  late final GeneratedColumn<DateTime> lastSynced = GeneratedColumn<DateTime>(
    'last_synced',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastModifiedMeta = const VerificationMeta(
    'lastModified',
  );
  @override
  late final GeneratedColumn<DateTime> lastModified = GeneratedColumn<DateTime>(
    'last_modified',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    age,
    gender,
    phone,
    email,
    medicalHistory,
    profileImage,
    isOnline,
    lastSynced,
    lastModified,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'patient_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<PatientProfile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('age')) {
      context.handle(
        _ageMeta,
        age.isAcceptableOrUnknown(data['age']!, _ageMeta),
      );
    } else if (isInserting) {
      context.missing(_ageMeta);
    }
    if (data.containsKey('gender')) {
      context.handle(
        _genderMeta,
        gender.isAcceptableOrUnknown(data['gender']!, _genderMeta),
      );
    } else if (isInserting) {
      context.missing(_genderMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    } else if (isInserting) {
      context.missing(_phoneMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('medical_history')) {
      context.handle(
        _medicalHistoryMeta,
        medicalHistory.isAcceptableOrUnknown(
          data['medical_history']!,
          _medicalHistoryMeta,
        ),
      );
    }
    if (data.containsKey('profile_image')) {
      context.handle(
        _profileImageMeta,
        profileImage.isAcceptableOrUnknown(
          data['profile_image']!,
          _profileImageMeta,
        ),
      );
    }
    if (data.containsKey('is_online')) {
      context.handle(
        _isOnlineMeta,
        isOnline.isAcceptableOrUnknown(data['is_online']!, _isOnlineMeta),
      );
    }
    if (data.containsKey('last_synced')) {
      context.handle(
        _lastSyncedMeta,
        lastSynced.isAcceptableOrUnknown(data['last_synced']!, _lastSyncedMeta),
      );
    }
    if (data.containsKey('last_modified')) {
      context.handle(
        _lastModifiedMeta,
        lastModified.isAcceptableOrUnknown(
          data['last_modified']!,
          _lastModifiedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastModifiedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PatientProfile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PatientProfile(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      age: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}age'],
      )!,
      gender: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gender'],
      )!,
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      medicalHistory: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}medical_history'],
      ),
      profileImage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profile_image'],
      ),
      isOnline: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_online'],
      )!,
      lastSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_synced'],
      ),
      lastModified: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_modified'],
      )!,
    );
  }

  @override
  $PatientProfilesTable createAlias(String alias) {
    return $PatientProfilesTable(attachedDatabase, alias);
  }
}

class PatientProfile extends DataClass implements Insertable<PatientProfile> {
  final String id;
  final String name;
  final String age;
  final String gender;
  final String phone;
  final String email;
  final String? medicalHistory;
  final String? profileImage;
  final bool isOnline;
  final DateTime? lastSynced;
  final DateTime lastModified;
  const PatientProfile({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.phone,
    required this.email,
    this.medicalHistory,
    this.profileImage,
    required this.isOnline,
    this.lastSynced,
    required this.lastModified,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['age'] = Variable<String>(age);
    map['gender'] = Variable<String>(gender);
    map['phone'] = Variable<String>(phone);
    map['email'] = Variable<String>(email);
    if (!nullToAbsent || medicalHistory != null) {
      map['medical_history'] = Variable<String>(medicalHistory);
    }
    if (!nullToAbsent || profileImage != null) {
      map['profile_image'] = Variable<String>(profileImage);
    }
    map['is_online'] = Variable<bool>(isOnline);
    if (!nullToAbsent || lastSynced != null) {
      map['last_synced'] = Variable<DateTime>(lastSynced);
    }
    map['last_modified'] = Variable<DateTime>(lastModified);
    return map;
  }

  PatientProfilesCompanion toCompanion(bool nullToAbsent) {
    return PatientProfilesCompanion(
      id: Value(id),
      name: Value(name),
      age: Value(age),
      gender: Value(gender),
      phone: Value(phone),
      email: Value(email),
      medicalHistory: medicalHistory == null && nullToAbsent
          ? const Value.absent()
          : Value(medicalHistory),
      profileImage: profileImage == null && nullToAbsent
          ? const Value.absent()
          : Value(profileImage),
      isOnline: Value(isOnline),
      lastSynced: lastSynced == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSynced),
      lastModified: Value(lastModified),
    );
  }

  factory PatientProfile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PatientProfile(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      age: serializer.fromJson<String>(json['age']),
      gender: serializer.fromJson<String>(json['gender']),
      phone: serializer.fromJson<String>(json['phone']),
      email: serializer.fromJson<String>(json['email']),
      medicalHistory: serializer.fromJson<String?>(json['medicalHistory']),
      profileImage: serializer.fromJson<String?>(json['profileImage']),
      isOnline: serializer.fromJson<bool>(json['isOnline']),
      lastSynced: serializer.fromJson<DateTime?>(json['lastSynced']),
      lastModified: serializer.fromJson<DateTime>(json['lastModified']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'age': serializer.toJson<String>(age),
      'gender': serializer.toJson<String>(gender),
      'phone': serializer.toJson<String>(phone),
      'email': serializer.toJson<String>(email),
      'medicalHistory': serializer.toJson<String?>(medicalHistory),
      'profileImage': serializer.toJson<String?>(profileImage),
      'isOnline': serializer.toJson<bool>(isOnline),
      'lastSynced': serializer.toJson<DateTime?>(lastSynced),
      'lastModified': serializer.toJson<DateTime>(lastModified),
    };
  }

  PatientProfile copyWith({
    String? id,
    String? name,
    String? age,
    String? gender,
    String? phone,
    String? email,
    Value<String?> medicalHistory = const Value.absent(),
    Value<String?> profileImage = const Value.absent(),
    bool? isOnline,
    Value<DateTime?> lastSynced = const Value.absent(),
    DateTime? lastModified,
  }) => PatientProfile(
    id: id ?? this.id,
    name: name ?? this.name,
    age: age ?? this.age,
    gender: gender ?? this.gender,
    phone: phone ?? this.phone,
    email: email ?? this.email,
    medicalHistory: medicalHistory.present
        ? medicalHistory.value
        : this.medicalHistory,
    profileImage: profileImage.present ? profileImage.value : this.profileImage,
    isOnline: isOnline ?? this.isOnline,
    lastSynced: lastSynced.present ? lastSynced.value : this.lastSynced,
    lastModified: lastModified ?? this.lastModified,
  );
  PatientProfile copyWithCompanion(PatientProfilesCompanion data) {
    return PatientProfile(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      age: data.age.present ? data.age.value : this.age,
      gender: data.gender.present ? data.gender.value : this.gender,
      phone: data.phone.present ? data.phone.value : this.phone,
      email: data.email.present ? data.email.value : this.email,
      medicalHistory: data.medicalHistory.present
          ? data.medicalHistory.value
          : this.medicalHistory,
      profileImage: data.profileImage.present
          ? data.profileImage.value
          : this.profileImage,
      isOnline: data.isOnline.present ? data.isOnline.value : this.isOnline,
      lastSynced: data.lastSynced.present
          ? data.lastSynced.value
          : this.lastSynced,
      lastModified: data.lastModified.present
          ? data.lastModified.value
          : this.lastModified,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PatientProfile(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('age: $age, ')
          ..write('gender: $gender, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('medicalHistory: $medicalHistory, ')
          ..write('profileImage: $profileImage, ')
          ..write('isOnline: $isOnline, ')
          ..write('lastSynced: $lastSynced, ')
          ..write('lastModified: $lastModified')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    age,
    gender,
    phone,
    email,
    medicalHistory,
    profileImage,
    isOnline,
    lastSynced,
    lastModified,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PatientProfile &&
          other.id == this.id &&
          other.name == this.name &&
          other.age == this.age &&
          other.gender == this.gender &&
          other.phone == this.phone &&
          other.email == this.email &&
          other.medicalHistory == this.medicalHistory &&
          other.profileImage == this.profileImage &&
          other.isOnline == this.isOnline &&
          other.lastSynced == this.lastSynced &&
          other.lastModified == this.lastModified);
}

class PatientProfilesCompanion extends UpdateCompanion<PatientProfile> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> age;
  final Value<String> gender;
  final Value<String> phone;
  final Value<String> email;
  final Value<String?> medicalHistory;
  final Value<String?> profileImage;
  final Value<bool> isOnline;
  final Value<DateTime?> lastSynced;
  final Value<DateTime> lastModified;
  final Value<int> rowid;
  const PatientProfilesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.age = const Value.absent(),
    this.gender = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.medicalHistory = const Value.absent(),
    this.profileImage = const Value.absent(),
    this.isOnline = const Value.absent(),
    this.lastSynced = const Value.absent(),
    this.lastModified = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PatientProfilesCompanion.insert({
    required String id,
    required String name,
    required String age,
    required String gender,
    required String phone,
    required String email,
    this.medicalHistory = const Value.absent(),
    this.profileImage = const Value.absent(),
    this.isOnline = const Value.absent(),
    this.lastSynced = const Value.absent(),
    required DateTime lastModified,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       age = Value(age),
       gender = Value(gender),
       phone = Value(phone),
       email = Value(email),
       lastModified = Value(lastModified);
  static Insertable<PatientProfile> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? age,
    Expression<String>? gender,
    Expression<String>? phone,
    Expression<String>? email,
    Expression<String>? medicalHistory,
    Expression<String>? profileImage,
    Expression<bool>? isOnline,
    Expression<DateTime>? lastSynced,
    Expression<DateTime>? lastModified,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (age != null) 'age': age,
      if (gender != null) 'gender': gender,
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
      if (medicalHistory != null) 'medical_history': medicalHistory,
      if (profileImage != null) 'profile_image': profileImage,
      if (isOnline != null) 'is_online': isOnline,
      if (lastSynced != null) 'last_synced': lastSynced,
      if (lastModified != null) 'last_modified': lastModified,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PatientProfilesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? age,
    Value<String>? gender,
    Value<String>? phone,
    Value<String>? email,
    Value<String?>? medicalHistory,
    Value<String?>? profileImage,
    Value<bool>? isOnline,
    Value<DateTime?>? lastSynced,
    Value<DateTime>? lastModified,
    Value<int>? rowid,
  }) {
    return PatientProfilesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      medicalHistory: medicalHistory ?? this.medicalHistory,
      profileImage: profileImage ?? this.profileImage,
      isOnline: isOnline ?? this.isOnline,
      lastSynced: lastSynced ?? this.lastSynced,
      lastModified: lastModified ?? this.lastModified,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (age.present) {
      map['age'] = Variable<String>(age.value);
    }
    if (gender.present) {
      map['gender'] = Variable<String>(gender.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (medicalHistory.present) {
      map['medical_history'] = Variable<String>(medicalHistory.value);
    }
    if (profileImage.present) {
      map['profile_image'] = Variable<String>(profileImage.value);
    }
    if (isOnline.present) {
      map['is_online'] = Variable<bool>(isOnline.value);
    }
    if (lastSynced.present) {
      map['last_synced'] = Variable<DateTime>(lastSynced.value);
    }
    if (lastModified.present) {
      map['last_modified'] = Variable<DateTime>(lastModified.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PatientProfilesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('age: $age, ')
          ..write('gender: $gender, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('medicalHistory: $medicalHistory, ')
          ..write('profileImage: $profileImage, ')
          ..write('isOnline: $isOnline, ')
          ..write('lastSynced: $lastSynced, ')
          ..write('lastModified: $lastModified, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UserProfilesTable extends UserProfiles
    with TableInfo<$UserProfilesTable, UserProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoneNumberMeta = const VerificationMeta(
    'phoneNumber',
  );
  @override
  late final GeneratedColumn<String> phoneNumber = GeneratedColumn<String>(
    'phone_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _passwordHashMeta = const VerificationMeta(
    'passwordHash',
  );
  @override
  late final GeneratedColumn<String> passwordHash = GeneratedColumn<String>(
    'password_hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fullNameMeta = const VerificationMeta(
    'fullName',
  );
  @override
  late final GeneratedColumn<String> fullName = GeneratedColumn<String>(
    'full_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isVerifiedMeta = const VerificationMeta(
    'isVerified',
  );
  @override
  late final GeneratedColumn<bool> isVerified = GeneratedColumn<bool>(
    'is_verified',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_verified" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastModifiedMeta = const VerificationMeta(
    'lastModified',
  );
  @override
  late final GeneratedColumn<DateTime> lastModified = GeneratedColumn<DateTime>(
    'last_modified',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    phoneNumber,
    passwordHash,
    fullName,
    email,
    isVerified,
    isActive,
    isSynced,
    createdAt,
    lastModified,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserProfile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('phone_number')) {
      context.handle(
        _phoneNumberMeta,
        phoneNumber.isAcceptableOrUnknown(
          data['phone_number']!,
          _phoneNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_phoneNumberMeta);
    }
    if (data.containsKey('password_hash')) {
      context.handle(
        _passwordHashMeta,
        passwordHash.isAcceptableOrUnknown(
          data['password_hash']!,
          _passwordHashMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_passwordHashMeta);
    }
    if (data.containsKey('full_name')) {
      context.handle(
        _fullNameMeta,
        fullName.isAcceptableOrUnknown(data['full_name']!, _fullNameMeta),
      );
    } else if (isInserting) {
      context.missing(_fullNameMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('is_verified')) {
      context.handle(
        _isVerifiedMeta,
        isVerified.isAcceptableOrUnknown(data['is_verified']!, _isVerifiedMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('last_modified')) {
      context.handle(
        _lastModifiedMeta,
        lastModified.isAcceptableOrUnknown(
          data['last_modified']!,
          _lastModifiedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastModifiedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserProfile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserProfile(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      phoneNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone_number'],
      )!,
      passwordHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}password_hash'],
      )!,
      fullName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}full_name'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
      isVerified: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_verified'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      lastModified: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_modified'],
      )!,
    );
  }

  @override
  $UserProfilesTable createAlias(String alias) {
    return $UserProfilesTable(attachedDatabase, alias);
  }
}

class UserProfile extends DataClass implements Insertable<UserProfile> {
  final String id;
  final String phoneNumber;
  final String passwordHash;
  final String fullName;
  final String? email;
  final bool isVerified;
  final bool isActive;
  final bool isSynced;
  final DateTime createdAt;
  final DateTime lastModified;
  const UserProfile({
    required this.id,
    required this.phoneNumber,
    required this.passwordHash,
    required this.fullName,
    this.email,
    required this.isVerified,
    required this.isActive,
    required this.isSynced,
    required this.createdAt,
    required this.lastModified,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['phone_number'] = Variable<String>(phoneNumber);
    map['password_hash'] = Variable<String>(passwordHash);
    map['full_name'] = Variable<String>(fullName);
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    map['is_verified'] = Variable<bool>(isVerified);
    map['is_active'] = Variable<bool>(isActive);
    map['is_synced'] = Variable<bool>(isSynced);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['last_modified'] = Variable<DateTime>(lastModified);
    return map;
  }

  UserProfilesCompanion toCompanion(bool nullToAbsent) {
    return UserProfilesCompanion(
      id: Value(id),
      phoneNumber: Value(phoneNumber),
      passwordHash: Value(passwordHash),
      fullName: Value(fullName),
      email: email == null && nullToAbsent
          ? const Value.absent()
          : Value(email),
      isVerified: Value(isVerified),
      isActive: Value(isActive),
      isSynced: Value(isSynced),
      createdAt: Value(createdAt),
      lastModified: Value(lastModified),
    );
  }

  factory UserProfile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserProfile(
      id: serializer.fromJson<String>(json['id']),
      phoneNumber: serializer.fromJson<String>(json['phoneNumber']),
      passwordHash: serializer.fromJson<String>(json['passwordHash']),
      fullName: serializer.fromJson<String>(json['fullName']),
      email: serializer.fromJson<String?>(json['email']),
      isVerified: serializer.fromJson<bool>(json['isVerified']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      lastModified: serializer.fromJson<DateTime>(json['lastModified']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'phoneNumber': serializer.toJson<String>(phoneNumber),
      'passwordHash': serializer.toJson<String>(passwordHash),
      'fullName': serializer.toJson<String>(fullName),
      'email': serializer.toJson<String?>(email),
      'isVerified': serializer.toJson<bool>(isVerified),
      'isActive': serializer.toJson<bool>(isActive),
      'isSynced': serializer.toJson<bool>(isSynced),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'lastModified': serializer.toJson<DateTime>(lastModified),
    };
  }

  UserProfile copyWith({
    String? id,
    String? phoneNumber,
    String? passwordHash,
    String? fullName,
    Value<String?> email = const Value.absent(),
    bool? isVerified,
    bool? isActive,
    bool? isSynced,
    DateTime? createdAt,
    DateTime? lastModified,
  }) => UserProfile(
    id: id ?? this.id,
    phoneNumber: phoneNumber ?? this.phoneNumber,
    passwordHash: passwordHash ?? this.passwordHash,
    fullName: fullName ?? this.fullName,
    email: email.present ? email.value : this.email,
    isVerified: isVerified ?? this.isVerified,
    isActive: isActive ?? this.isActive,
    isSynced: isSynced ?? this.isSynced,
    createdAt: createdAt ?? this.createdAt,
    lastModified: lastModified ?? this.lastModified,
  );
  UserProfile copyWithCompanion(UserProfilesCompanion data) {
    return UserProfile(
      id: data.id.present ? data.id.value : this.id,
      phoneNumber: data.phoneNumber.present
          ? data.phoneNumber.value
          : this.phoneNumber,
      passwordHash: data.passwordHash.present
          ? data.passwordHash.value
          : this.passwordHash,
      fullName: data.fullName.present ? data.fullName.value : this.fullName,
      email: data.email.present ? data.email.value : this.email,
      isVerified: data.isVerified.present
          ? data.isVerified.value
          : this.isVerified,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      lastModified: data.lastModified.present
          ? data.lastModified.value
          : this.lastModified,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserProfile(')
          ..write('id: $id, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('passwordHash: $passwordHash, ')
          ..write('fullName: $fullName, ')
          ..write('email: $email, ')
          ..write('isVerified: $isVerified, ')
          ..write('isActive: $isActive, ')
          ..write('isSynced: $isSynced, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastModified: $lastModified')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    phoneNumber,
    passwordHash,
    fullName,
    email,
    isVerified,
    isActive,
    isSynced,
    createdAt,
    lastModified,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserProfile &&
          other.id == this.id &&
          other.phoneNumber == this.phoneNumber &&
          other.passwordHash == this.passwordHash &&
          other.fullName == this.fullName &&
          other.email == this.email &&
          other.isVerified == this.isVerified &&
          other.isActive == this.isActive &&
          other.isSynced == this.isSynced &&
          other.createdAt == this.createdAt &&
          other.lastModified == this.lastModified);
}

class UserProfilesCompanion extends UpdateCompanion<UserProfile> {
  final Value<String> id;
  final Value<String> phoneNumber;
  final Value<String> passwordHash;
  final Value<String> fullName;
  final Value<String?> email;
  final Value<bool> isVerified;
  final Value<bool> isActive;
  final Value<bool> isSynced;
  final Value<DateTime> createdAt;
  final Value<DateTime> lastModified;
  final Value<int> rowid;
  const UserProfilesCompanion({
    this.id = const Value.absent(),
    this.phoneNumber = const Value.absent(),
    this.passwordHash = const Value.absent(),
    this.fullName = const Value.absent(),
    this.email = const Value.absent(),
    this.isVerified = const Value.absent(),
    this.isActive = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastModified = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserProfilesCompanion.insert({
    required String id,
    required String phoneNumber,
    required String passwordHash,
    required String fullName,
    this.email = const Value.absent(),
    this.isVerified = const Value.absent(),
    this.isActive = const Value.absent(),
    this.isSynced = const Value.absent(),
    required DateTime createdAt,
    required DateTime lastModified,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       phoneNumber = Value(phoneNumber),
       passwordHash = Value(passwordHash),
       fullName = Value(fullName),
       createdAt = Value(createdAt),
       lastModified = Value(lastModified);
  static Insertable<UserProfile> custom({
    Expression<String>? id,
    Expression<String>? phoneNumber,
    Expression<String>? passwordHash,
    Expression<String>? fullName,
    Expression<String>? email,
    Expression<bool>? isVerified,
    Expression<bool>? isActive,
    Expression<bool>? isSynced,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? lastModified,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (phoneNumber != null) 'phone_number': phoneNumber,
      if (passwordHash != null) 'password_hash': passwordHash,
      if (fullName != null) 'full_name': fullName,
      if (email != null) 'email': email,
      if (isVerified != null) 'is_verified': isVerified,
      if (isActive != null) 'is_active': isActive,
      if (isSynced != null) 'is_synced': isSynced,
      if (createdAt != null) 'created_at': createdAt,
      if (lastModified != null) 'last_modified': lastModified,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserProfilesCompanion copyWith({
    Value<String>? id,
    Value<String>? phoneNumber,
    Value<String>? passwordHash,
    Value<String>? fullName,
    Value<String?>? email,
    Value<bool>? isVerified,
    Value<bool>? isActive,
    Value<bool>? isSynced,
    Value<DateTime>? createdAt,
    Value<DateTime>? lastModified,
    Value<int>? rowid,
  }) {
    return UserProfilesCompanion(
      id: id ?? this.id,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      passwordHash: passwordHash ?? this.passwordHash,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      isVerified: isVerified ?? this.isVerified,
      isActive: isActive ?? this.isActive,
      isSynced: isSynced ?? this.isSynced,
      createdAt: createdAt ?? this.createdAt,
      lastModified: lastModified ?? this.lastModified,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (phoneNumber.present) {
      map['phone_number'] = Variable<String>(phoneNumber.value);
    }
    if (passwordHash.present) {
      map['password_hash'] = Variable<String>(passwordHash.value);
    }
    if (fullName.present) {
      map['full_name'] = Variable<String>(fullName.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (isVerified.present) {
      map['is_verified'] = Variable<bool>(isVerified.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (lastModified.present) {
      map['last_modified'] = Variable<DateTime>(lastModified.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserProfilesCompanion(')
          ..write('id: $id, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('passwordHash: $passwordHash, ')
          ..write('fullName: $fullName, ')
          ..write('email: $email, ')
          ..write('isVerified: $isVerified, ')
          ..write('isActive: $isActive, ')
          ..write('isSynced: $isSynced, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastModified: $lastModified, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OfflineAppointmentsTable extends OfflineAppointments
    with TableInfo<$OfflineAppointmentsTable, OfflineAppointment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OfflineAppointmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _patientIdMeta = const VerificationMeta(
    'patientId',
  );
  @override
  late final GeneratedColumn<String> patientId = GeneratedColumn<String>(
    'patient_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _patientNameMeta = const VerificationMeta(
    'patientName',
  );
  @override
  late final GeneratedColumn<String> patientName = GeneratedColumn<String>(
    'patient_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _patientAgeMeta = const VerificationMeta(
    'patientAge',
  );
  @override
  late final GeneratedColumn<String> patientAge = GeneratedColumn<String>(
    'patient_age',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _patientGenderMeta = const VerificationMeta(
    'patientGender',
  );
  @override
  late final GeneratedColumn<String> patientGender = GeneratedColumn<String>(
    'patient_gender',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _symptomsMeta = const VerificationMeta(
    'symptoms',
  );
  @override
  late final GeneratedColumn<String> symptoms = GeneratedColumn<String>(
    'symptoms',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _medicalHistoryMeta = const VerificationMeta(
    'medicalHistory',
  );
  @override
  late final GeneratedColumn<String> medicalHistory = GeneratedColumn<String>(
    'medical_history',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _preferredTimeMeta = const VerificationMeta(
    'preferredTime',
  );
  @override
  late final GeneratedColumn<String> preferredTime = GeneratedColumn<String>(
    'preferred_time',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _priorityMeta = const VerificationMeta(
    'priority',
  );
  @override
  late final GeneratedColumn<String> priority = GeneratedColumn<String>(
    'priority',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('normal'),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('waiting'),
  );
  static const VerificationMeta _doctorIdMeta = const VerificationMeta(
    'doctorId',
  );
  @override
  late final GeneratedColumn<String> doctorId = GeneratedColumn<String>(
    'doctor_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastModifiedMeta = const VerificationMeta(
    'lastModified',
  );
  @override
  late final GeneratedColumn<DateTime> lastModified = GeneratedColumn<DateTime>(
    'last_modified',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    patientId,
    patientName,
    patientAge,
    patientGender,
    symptoms,
    medicalHistory,
    preferredTime,
    priority,
    status,
    doctorId,
    createdAt,
    lastModified,
    isSynced,
    isDeleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'offline_appointments';
  @override
  VerificationContext validateIntegrity(
    Insertable<OfflineAppointment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('patient_id')) {
      context.handle(
        _patientIdMeta,
        patientId.isAcceptableOrUnknown(data['patient_id']!, _patientIdMeta),
      );
    } else if (isInserting) {
      context.missing(_patientIdMeta);
    }
    if (data.containsKey('patient_name')) {
      context.handle(
        _patientNameMeta,
        patientName.isAcceptableOrUnknown(
          data['patient_name']!,
          _patientNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_patientNameMeta);
    }
    if (data.containsKey('patient_age')) {
      context.handle(
        _patientAgeMeta,
        patientAge.isAcceptableOrUnknown(data['patient_age']!, _patientAgeMeta),
      );
    } else if (isInserting) {
      context.missing(_patientAgeMeta);
    }
    if (data.containsKey('patient_gender')) {
      context.handle(
        _patientGenderMeta,
        patientGender.isAcceptableOrUnknown(
          data['patient_gender']!,
          _patientGenderMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_patientGenderMeta);
    }
    if (data.containsKey('symptoms')) {
      context.handle(
        _symptomsMeta,
        symptoms.isAcceptableOrUnknown(data['symptoms']!, _symptomsMeta),
      );
    } else if (isInserting) {
      context.missing(_symptomsMeta);
    }
    if (data.containsKey('medical_history')) {
      context.handle(
        _medicalHistoryMeta,
        medicalHistory.isAcceptableOrUnknown(
          data['medical_history']!,
          _medicalHistoryMeta,
        ),
      );
    }
    if (data.containsKey('preferred_time')) {
      context.handle(
        _preferredTimeMeta,
        preferredTime.isAcceptableOrUnknown(
          data['preferred_time']!,
          _preferredTimeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_preferredTimeMeta);
    }
    if (data.containsKey('priority')) {
      context.handle(
        _priorityMeta,
        priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('doctor_id')) {
      context.handle(
        _doctorIdMeta,
        doctorId.isAcceptableOrUnknown(data['doctor_id']!, _doctorIdMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('last_modified')) {
      context.handle(
        _lastModifiedMeta,
        lastModified.isAcceptableOrUnknown(
          data['last_modified']!,
          _lastModifiedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastModifiedMeta);
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OfflineAppointment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OfflineAppointment(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      patientId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}patient_id'],
      )!,
      patientName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}patient_name'],
      )!,
      patientAge: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}patient_age'],
      )!,
      patientGender: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}patient_gender'],
      )!,
      symptoms: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}symptoms'],
      )!,
      medicalHistory: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}medical_history'],
      ),
      preferredTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}preferred_time'],
      )!,
      priority: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}priority'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      doctorId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}doctor_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      lastModified: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_modified'],
      )!,
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
    );
  }

  @override
  $OfflineAppointmentsTable createAlias(String alias) {
    return $OfflineAppointmentsTable(attachedDatabase, alias);
  }
}

class OfflineAppointment extends DataClass
    implements Insertable<OfflineAppointment> {
  final String id;
  final String patientId;
  final String patientName;
  final String patientAge;
  final String patientGender;
  final String symptoms;
  final String? medicalHistory;
  final String preferredTime;
  final String priority;
  final String status;
  final String? doctorId;
  final DateTime createdAt;
  final DateTime lastModified;
  final bool isSynced;
  final bool isDeleted;
  const OfflineAppointment({
    required this.id,
    required this.patientId,
    required this.patientName,
    required this.patientAge,
    required this.patientGender,
    required this.symptoms,
    this.medicalHistory,
    required this.preferredTime,
    required this.priority,
    required this.status,
    this.doctorId,
    required this.createdAt,
    required this.lastModified,
    required this.isSynced,
    required this.isDeleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['patient_id'] = Variable<String>(patientId);
    map['patient_name'] = Variable<String>(patientName);
    map['patient_age'] = Variable<String>(patientAge);
    map['patient_gender'] = Variable<String>(patientGender);
    map['symptoms'] = Variable<String>(symptoms);
    if (!nullToAbsent || medicalHistory != null) {
      map['medical_history'] = Variable<String>(medicalHistory);
    }
    map['preferred_time'] = Variable<String>(preferredTime);
    map['priority'] = Variable<String>(priority);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || doctorId != null) {
      map['doctor_id'] = Variable<String>(doctorId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['last_modified'] = Variable<DateTime>(lastModified);
    map['is_synced'] = Variable<bool>(isSynced);
    map['is_deleted'] = Variable<bool>(isDeleted);
    return map;
  }

  OfflineAppointmentsCompanion toCompanion(bool nullToAbsent) {
    return OfflineAppointmentsCompanion(
      id: Value(id),
      patientId: Value(patientId),
      patientName: Value(patientName),
      patientAge: Value(patientAge),
      patientGender: Value(patientGender),
      symptoms: Value(symptoms),
      medicalHistory: medicalHistory == null && nullToAbsent
          ? const Value.absent()
          : Value(medicalHistory),
      preferredTime: Value(preferredTime),
      priority: Value(priority),
      status: Value(status),
      doctorId: doctorId == null && nullToAbsent
          ? const Value.absent()
          : Value(doctorId),
      createdAt: Value(createdAt),
      lastModified: Value(lastModified),
      isSynced: Value(isSynced),
      isDeleted: Value(isDeleted),
    );
  }

  factory OfflineAppointment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OfflineAppointment(
      id: serializer.fromJson<String>(json['id']),
      patientId: serializer.fromJson<String>(json['patientId']),
      patientName: serializer.fromJson<String>(json['patientName']),
      patientAge: serializer.fromJson<String>(json['patientAge']),
      patientGender: serializer.fromJson<String>(json['patientGender']),
      symptoms: serializer.fromJson<String>(json['symptoms']),
      medicalHistory: serializer.fromJson<String?>(json['medicalHistory']),
      preferredTime: serializer.fromJson<String>(json['preferredTime']),
      priority: serializer.fromJson<String>(json['priority']),
      status: serializer.fromJson<String>(json['status']),
      doctorId: serializer.fromJson<String?>(json['doctorId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      lastModified: serializer.fromJson<DateTime>(json['lastModified']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'patientId': serializer.toJson<String>(patientId),
      'patientName': serializer.toJson<String>(patientName),
      'patientAge': serializer.toJson<String>(patientAge),
      'patientGender': serializer.toJson<String>(patientGender),
      'symptoms': serializer.toJson<String>(symptoms),
      'medicalHistory': serializer.toJson<String?>(medicalHistory),
      'preferredTime': serializer.toJson<String>(preferredTime),
      'priority': serializer.toJson<String>(priority),
      'status': serializer.toJson<String>(status),
      'doctorId': serializer.toJson<String?>(doctorId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'lastModified': serializer.toJson<DateTime>(lastModified),
      'isSynced': serializer.toJson<bool>(isSynced),
      'isDeleted': serializer.toJson<bool>(isDeleted),
    };
  }

  OfflineAppointment copyWith({
    String? id,
    String? patientId,
    String? patientName,
    String? patientAge,
    String? patientGender,
    String? symptoms,
    Value<String?> medicalHistory = const Value.absent(),
    String? preferredTime,
    String? priority,
    String? status,
    Value<String?> doctorId = const Value.absent(),
    DateTime? createdAt,
    DateTime? lastModified,
    bool? isSynced,
    bool? isDeleted,
  }) => OfflineAppointment(
    id: id ?? this.id,
    patientId: patientId ?? this.patientId,
    patientName: patientName ?? this.patientName,
    patientAge: patientAge ?? this.patientAge,
    patientGender: patientGender ?? this.patientGender,
    symptoms: symptoms ?? this.symptoms,
    medicalHistory: medicalHistory.present
        ? medicalHistory.value
        : this.medicalHistory,
    preferredTime: preferredTime ?? this.preferredTime,
    priority: priority ?? this.priority,
    status: status ?? this.status,
    doctorId: doctorId.present ? doctorId.value : this.doctorId,
    createdAt: createdAt ?? this.createdAt,
    lastModified: lastModified ?? this.lastModified,
    isSynced: isSynced ?? this.isSynced,
    isDeleted: isDeleted ?? this.isDeleted,
  );
  OfflineAppointment copyWithCompanion(OfflineAppointmentsCompanion data) {
    return OfflineAppointment(
      id: data.id.present ? data.id.value : this.id,
      patientId: data.patientId.present ? data.patientId.value : this.patientId,
      patientName: data.patientName.present
          ? data.patientName.value
          : this.patientName,
      patientAge: data.patientAge.present
          ? data.patientAge.value
          : this.patientAge,
      patientGender: data.patientGender.present
          ? data.patientGender.value
          : this.patientGender,
      symptoms: data.symptoms.present ? data.symptoms.value : this.symptoms,
      medicalHistory: data.medicalHistory.present
          ? data.medicalHistory.value
          : this.medicalHistory,
      preferredTime: data.preferredTime.present
          ? data.preferredTime.value
          : this.preferredTime,
      priority: data.priority.present ? data.priority.value : this.priority,
      status: data.status.present ? data.status.value : this.status,
      doctorId: data.doctorId.present ? data.doctorId.value : this.doctorId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      lastModified: data.lastModified.present
          ? data.lastModified.value
          : this.lastModified,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OfflineAppointment(')
          ..write('id: $id, ')
          ..write('patientId: $patientId, ')
          ..write('patientName: $patientName, ')
          ..write('patientAge: $patientAge, ')
          ..write('patientGender: $patientGender, ')
          ..write('symptoms: $symptoms, ')
          ..write('medicalHistory: $medicalHistory, ')
          ..write('preferredTime: $preferredTime, ')
          ..write('priority: $priority, ')
          ..write('status: $status, ')
          ..write('doctorId: $doctorId, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastModified: $lastModified, ')
          ..write('isSynced: $isSynced, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    patientId,
    patientName,
    patientAge,
    patientGender,
    symptoms,
    medicalHistory,
    preferredTime,
    priority,
    status,
    doctorId,
    createdAt,
    lastModified,
    isSynced,
    isDeleted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OfflineAppointment &&
          other.id == this.id &&
          other.patientId == this.patientId &&
          other.patientName == this.patientName &&
          other.patientAge == this.patientAge &&
          other.patientGender == this.patientGender &&
          other.symptoms == this.symptoms &&
          other.medicalHistory == this.medicalHistory &&
          other.preferredTime == this.preferredTime &&
          other.priority == this.priority &&
          other.status == this.status &&
          other.doctorId == this.doctorId &&
          other.createdAt == this.createdAt &&
          other.lastModified == this.lastModified &&
          other.isSynced == this.isSynced &&
          other.isDeleted == this.isDeleted);
}

class OfflineAppointmentsCompanion extends UpdateCompanion<OfflineAppointment> {
  final Value<String> id;
  final Value<String> patientId;
  final Value<String> patientName;
  final Value<String> patientAge;
  final Value<String> patientGender;
  final Value<String> symptoms;
  final Value<String?> medicalHistory;
  final Value<String> preferredTime;
  final Value<String> priority;
  final Value<String> status;
  final Value<String?> doctorId;
  final Value<DateTime> createdAt;
  final Value<DateTime> lastModified;
  final Value<bool> isSynced;
  final Value<bool> isDeleted;
  final Value<int> rowid;
  const OfflineAppointmentsCompanion({
    this.id = const Value.absent(),
    this.patientId = const Value.absent(),
    this.patientName = const Value.absent(),
    this.patientAge = const Value.absent(),
    this.patientGender = const Value.absent(),
    this.symptoms = const Value.absent(),
    this.medicalHistory = const Value.absent(),
    this.preferredTime = const Value.absent(),
    this.priority = const Value.absent(),
    this.status = const Value.absent(),
    this.doctorId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastModified = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OfflineAppointmentsCompanion.insert({
    required String id,
    required String patientId,
    required String patientName,
    required String patientAge,
    required String patientGender,
    required String symptoms,
    this.medicalHistory = const Value.absent(),
    required String preferredTime,
    this.priority = const Value.absent(),
    this.status = const Value.absent(),
    this.doctorId = const Value.absent(),
    required DateTime createdAt,
    required DateTime lastModified,
    this.isSynced = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       patientId = Value(patientId),
       patientName = Value(patientName),
       patientAge = Value(patientAge),
       patientGender = Value(patientGender),
       symptoms = Value(symptoms),
       preferredTime = Value(preferredTime),
       createdAt = Value(createdAt),
       lastModified = Value(lastModified);
  static Insertable<OfflineAppointment> custom({
    Expression<String>? id,
    Expression<String>? patientId,
    Expression<String>? patientName,
    Expression<String>? patientAge,
    Expression<String>? patientGender,
    Expression<String>? symptoms,
    Expression<String>? medicalHistory,
    Expression<String>? preferredTime,
    Expression<String>? priority,
    Expression<String>? status,
    Expression<String>? doctorId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? lastModified,
    Expression<bool>? isSynced,
    Expression<bool>? isDeleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (patientId != null) 'patient_id': patientId,
      if (patientName != null) 'patient_name': patientName,
      if (patientAge != null) 'patient_age': patientAge,
      if (patientGender != null) 'patient_gender': patientGender,
      if (symptoms != null) 'symptoms': symptoms,
      if (medicalHistory != null) 'medical_history': medicalHistory,
      if (preferredTime != null) 'preferred_time': preferredTime,
      if (priority != null) 'priority': priority,
      if (status != null) 'status': status,
      if (doctorId != null) 'doctor_id': doctorId,
      if (createdAt != null) 'created_at': createdAt,
      if (lastModified != null) 'last_modified': lastModified,
      if (isSynced != null) 'is_synced': isSynced,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OfflineAppointmentsCompanion copyWith({
    Value<String>? id,
    Value<String>? patientId,
    Value<String>? patientName,
    Value<String>? patientAge,
    Value<String>? patientGender,
    Value<String>? symptoms,
    Value<String?>? medicalHistory,
    Value<String>? preferredTime,
    Value<String>? priority,
    Value<String>? status,
    Value<String?>? doctorId,
    Value<DateTime>? createdAt,
    Value<DateTime>? lastModified,
    Value<bool>? isSynced,
    Value<bool>? isDeleted,
    Value<int>? rowid,
  }) {
    return OfflineAppointmentsCompanion(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      patientName: patientName ?? this.patientName,
      patientAge: patientAge ?? this.patientAge,
      patientGender: patientGender ?? this.patientGender,
      symptoms: symptoms ?? this.symptoms,
      medicalHistory: medicalHistory ?? this.medicalHistory,
      preferredTime: preferredTime ?? this.preferredTime,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      doctorId: doctorId ?? this.doctorId,
      createdAt: createdAt ?? this.createdAt,
      lastModified: lastModified ?? this.lastModified,
      isSynced: isSynced ?? this.isSynced,
      isDeleted: isDeleted ?? this.isDeleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (patientId.present) {
      map['patient_id'] = Variable<String>(patientId.value);
    }
    if (patientName.present) {
      map['patient_name'] = Variable<String>(patientName.value);
    }
    if (patientAge.present) {
      map['patient_age'] = Variable<String>(patientAge.value);
    }
    if (patientGender.present) {
      map['patient_gender'] = Variable<String>(patientGender.value);
    }
    if (symptoms.present) {
      map['symptoms'] = Variable<String>(symptoms.value);
    }
    if (medicalHistory.present) {
      map['medical_history'] = Variable<String>(medicalHistory.value);
    }
    if (preferredTime.present) {
      map['preferred_time'] = Variable<String>(preferredTime.value);
    }
    if (priority.present) {
      map['priority'] = Variable<String>(priority.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (doctorId.present) {
      map['doctor_id'] = Variable<String>(doctorId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (lastModified.present) {
      map['last_modified'] = Variable<DateTime>(lastModified.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OfflineAppointmentsCompanion(')
          ..write('id: $id, ')
          ..write('patientId: $patientId, ')
          ..write('patientName: $patientName, ')
          ..write('patientAge: $patientAge, ')
          ..write('patientGender: $patientGender, ')
          ..write('symptoms: $symptoms, ')
          ..write('medicalHistory: $medicalHistory, ')
          ..write('preferredTime: $preferredTime, ')
          ..write('priority: $priority, ')
          ..write('status: $status, ')
          ..write('doctorId: $doctorId, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastModified: $lastModified, ')
          ..write('isSynced: $isSynced, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CachedPrescriptionsTable extends CachedPrescriptions
    with TableInfo<$CachedPrescriptionsTable, CachedPrescription> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedPrescriptionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _appointmentIdMeta = const VerificationMeta(
    'appointmentId',
  );
  @override
  late final GeneratedColumn<String> appointmentId = GeneratedColumn<String>(
    'appointment_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _patientIdMeta = const VerificationMeta(
    'patientId',
  );
  @override
  late final GeneratedColumn<String> patientId = GeneratedColumn<String>(
    'patient_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _doctorIdMeta = const VerificationMeta(
    'doctorId',
  );
  @override
  late final GeneratedColumn<String> doctorId = GeneratedColumn<String>(
    'doctor_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _doctorNameMeta = const VerificationMeta(
    'doctorName',
  );
  @override
  late final GeneratedColumn<String> doctorName = GeneratedColumn<String>(
    'doctor_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _medicationsMeta = const VerificationMeta(
    'medications',
  );
  @override
  late final GeneratedColumn<String> medications = GeneratedColumn<String>(
    'medications',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dosageMeta = const VerificationMeta('dosage');
  @override
  late final GeneratedColumn<String> dosage = GeneratedColumn<String>(
    'dosage',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _instructionsMeta = const VerificationMeta(
    'instructions',
  );
  @override
  late final GeneratedColumn<String> instructions = GeneratedColumn<String>(
    'instructions',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationMeta = const VerificationMeta(
    'duration',
  );
  @override
  late final GeneratedColumn<String> duration = GeneratedColumn<String>(
    'duration',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _prescribedAtMeta = const VerificationMeta(
    'prescribedAt',
  );
  @override
  late final GeneratedColumn<DateTime> prescribedAt = GeneratedColumn<DateTime>(
    'prescribed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cachedAtMeta = const VerificationMeta(
    'cachedAt',
  );
  @override
  late final GeneratedColumn<DateTime> cachedAt = GeneratedColumn<DateTime>(
    'cached_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isOfflineAccessedMeta = const VerificationMeta(
    'isOfflineAccessed',
  );
  @override
  late final GeneratedColumn<bool> isOfflineAccessed = GeneratedColumn<bool>(
    'is_offline_accessed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_offline_accessed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    appointmentId,
    patientId,
    doctorId,
    doctorName,
    medications,
    dosage,
    instructions,
    duration,
    prescribedAt,
    cachedAt,
    isOfflineAccessed,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_prescriptions';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedPrescription> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('appointment_id')) {
      context.handle(
        _appointmentIdMeta,
        appointmentId.isAcceptableOrUnknown(
          data['appointment_id']!,
          _appointmentIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_appointmentIdMeta);
    }
    if (data.containsKey('patient_id')) {
      context.handle(
        _patientIdMeta,
        patientId.isAcceptableOrUnknown(data['patient_id']!, _patientIdMeta),
      );
    } else if (isInserting) {
      context.missing(_patientIdMeta);
    }
    if (data.containsKey('doctor_id')) {
      context.handle(
        _doctorIdMeta,
        doctorId.isAcceptableOrUnknown(data['doctor_id']!, _doctorIdMeta),
      );
    } else if (isInserting) {
      context.missing(_doctorIdMeta);
    }
    if (data.containsKey('doctor_name')) {
      context.handle(
        _doctorNameMeta,
        doctorName.isAcceptableOrUnknown(data['doctor_name']!, _doctorNameMeta),
      );
    } else if (isInserting) {
      context.missing(_doctorNameMeta);
    }
    if (data.containsKey('medications')) {
      context.handle(
        _medicationsMeta,
        medications.isAcceptableOrUnknown(
          data['medications']!,
          _medicationsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_medicationsMeta);
    }
    if (data.containsKey('dosage')) {
      context.handle(
        _dosageMeta,
        dosage.isAcceptableOrUnknown(data['dosage']!, _dosageMeta),
      );
    } else if (isInserting) {
      context.missing(_dosageMeta);
    }
    if (data.containsKey('instructions')) {
      context.handle(
        _instructionsMeta,
        instructions.isAcceptableOrUnknown(
          data['instructions']!,
          _instructionsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_instructionsMeta);
    }
    if (data.containsKey('duration')) {
      context.handle(
        _durationMeta,
        duration.isAcceptableOrUnknown(data['duration']!, _durationMeta),
      );
    } else if (isInserting) {
      context.missing(_durationMeta);
    }
    if (data.containsKey('prescribed_at')) {
      context.handle(
        _prescribedAtMeta,
        prescribedAt.isAcceptableOrUnknown(
          data['prescribed_at']!,
          _prescribedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_prescribedAtMeta);
    }
    if (data.containsKey('cached_at')) {
      context.handle(
        _cachedAtMeta,
        cachedAt.isAcceptableOrUnknown(data['cached_at']!, _cachedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_cachedAtMeta);
    }
    if (data.containsKey('is_offline_accessed')) {
      context.handle(
        _isOfflineAccessedMeta,
        isOfflineAccessed.isAcceptableOrUnknown(
          data['is_offline_accessed']!,
          _isOfflineAccessedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CachedPrescription map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedPrescription(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      appointmentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}appointment_id'],
      )!,
      patientId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}patient_id'],
      )!,
      doctorId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}doctor_id'],
      )!,
      doctorName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}doctor_name'],
      )!,
      medications: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}medications'],
      )!,
      dosage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dosage'],
      )!,
      instructions: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}instructions'],
      )!,
      duration: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}duration'],
      )!,
      prescribedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}prescribed_at'],
      )!,
      cachedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cached_at'],
      )!,
      isOfflineAccessed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_offline_accessed'],
      )!,
    );
  }

  @override
  $CachedPrescriptionsTable createAlias(String alias) {
    return $CachedPrescriptionsTable(attachedDatabase, alias);
  }
}

class CachedPrescription extends DataClass
    implements Insertable<CachedPrescription> {
  final String id;
  final String appointmentId;
  final String patientId;
  final String doctorId;
  final String doctorName;
  final String medications;
  final String dosage;
  final String instructions;
  final String duration;
  final DateTime prescribedAt;
  final DateTime cachedAt;
  final bool isOfflineAccessed;
  const CachedPrescription({
    required this.id,
    required this.appointmentId,
    required this.patientId,
    required this.doctorId,
    required this.doctorName,
    required this.medications,
    required this.dosage,
    required this.instructions,
    required this.duration,
    required this.prescribedAt,
    required this.cachedAt,
    required this.isOfflineAccessed,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['appointment_id'] = Variable<String>(appointmentId);
    map['patient_id'] = Variable<String>(patientId);
    map['doctor_id'] = Variable<String>(doctorId);
    map['doctor_name'] = Variable<String>(doctorName);
    map['medications'] = Variable<String>(medications);
    map['dosage'] = Variable<String>(dosage);
    map['instructions'] = Variable<String>(instructions);
    map['duration'] = Variable<String>(duration);
    map['prescribed_at'] = Variable<DateTime>(prescribedAt);
    map['cached_at'] = Variable<DateTime>(cachedAt);
    map['is_offline_accessed'] = Variable<bool>(isOfflineAccessed);
    return map;
  }

  CachedPrescriptionsCompanion toCompanion(bool nullToAbsent) {
    return CachedPrescriptionsCompanion(
      id: Value(id),
      appointmentId: Value(appointmentId),
      patientId: Value(patientId),
      doctorId: Value(doctorId),
      doctorName: Value(doctorName),
      medications: Value(medications),
      dosage: Value(dosage),
      instructions: Value(instructions),
      duration: Value(duration),
      prescribedAt: Value(prescribedAt),
      cachedAt: Value(cachedAt),
      isOfflineAccessed: Value(isOfflineAccessed),
    );
  }

  factory CachedPrescription.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedPrescription(
      id: serializer.fromJson<String>(json['id']),
      appointmentId: serializer.fromJson<String>(json['appointmentId']),
      patientId: serializer.fromJson<String>(json['patientId']),
      doctorId: serializer.fromJson<String>(json['doctorId']),
      doctorName: serializer.fromJson<String>(json['doctorName']),
      medications: serializer.fromJson<String>(json['medications']),
      dosage: serializer.fromJson<String>(json['dosage']),
      instructions: serializer.fromJson<String>(json['instructions']),
      duration: serializer.fromJson<String>(json['duration']),
      prescribedAt: serializer.fromJson<DateTime>(json['prescribedAt']),
      cachedAt: serializer.fromJson<DateTime>(json['cachedAt']),
      isOfflineAccessed: serializer.fromJson<bool>(json['isOfflineAccessed']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'appointmentId': serializer.toJson<String>(appointmentId),
      'patientId': serializer.toJson<String>(patientId),
      'doctorId': serializer.toJson<String>(doctorId),
      'doctorName': serializer.toJson<String>(doctorName),
      'medications': serializer.toJson<String>(medications),
      'dosage': serializer.toJson<String>(dosage),
      'instructions': serializer.toJson<String>(instructions),
      'duration': serializer.toJson<String>(duration),
      'prescribedAt': serializer.toJson<DateTime>(prescribedAt),
      'cachedAt': serializer.toJson<DateTime>(cachedAt),
      'isOfflineAccessed': serializer.toJson<bool>(isOfflineAccessed),
    };
  }

  CachedPrescription copyWith({
    String? id,
    String? appointmentId,
    String? patientId,
    String? doctorId,
    String? doctorName,
    String? medications,
    String? dosage,
    String? instructions,
    String? duration,
    DateTime? prescribedAt,
    DateTime? cachedAt,
    bool? isOfflineAccessed,
  }) => CachedPrescription(
    id: id ?? this.id,
    appointmentId: appointmentId ?? this.appointmentId,
    patientId: patientId ?? this.patientId,
    doctorId: doctorId ?? this.doctorId,
    doctorName: doctorName ?? this.doctorName,
    medications: medications ?? this.medications,
    dosage: dosage ?? this.dosage,
    instructions: instructions ?? this.instructions,
    duration: duration ?? this.duration,
    prescribedAt: prescribedAt ?? this.prescribedAt,
    cachedAt: cachedAt ?? this.cachedAt,
    isOfflineAccessed: isOfflineAccessed ?? this.isOfflineAccessed,
  );
  CachedPrescription copyWithCompanion(CachedPrescriptionsCompanion data) {
    return CachedPrescription(
      id: data.id.present ? data.id.value : this.id,
      appointmentId: data.appointmentId.present
          ? data.appointmentId.value
          : this.appointmentId,
      patientId: data.patientId.present ? data.patientId.value : this.patientId,
      doctorId: data.doctorId.present ? data.doctorId.value : this.doctorId,
      doctorName: data.doctorName.present
          ? data.doctorName.value
          : this.doctorName,
      medications: data.medications.present
          ? data.medications.value
          : this.medications,
      dosage: data.dosage.present ? data.dosage.value : this.dosage,
      instructions: data.instructions.present
          ? data.instructions.value
          : this.instructions,
      duration: data.duration.present ? data.duration.value : this.duration,
      prescribedAt: data.prescribedAt.present
          ? data.prescribedAt.value
          : this.prescribedAt,
      cachedAt: data.cachedAt.present ? data.cachedAt.value : this.cachedAt,
      isOfflineAccessed: data.isOfflineAccessed.present
          ? data.isOfflineAccessed.value
          : this.isOfflineAccessed,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedPrescription(')
          ..write('id: $id, ')
          ..write('appointmentId: $appointmentId, ')
          ..write('patientId: $patientId, ')
          ..write('doctorId: $doctorId, ')
          ..write('doctorName: $doctorName, ')
          ..write('medications: $medications, ')
          ..write('dosage: $dosage, ')
          ..write('instructions: $instructions, ')
          ..write('duration: $duration, ')
          ..write('prescribedAt: $prescribedAt, ')
          ..write('cachedAt: $cachedAt, ')
          ..write('isOfflineAccessed: $isOfflineAccessed')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    appointmentId,
    patientId,
    doctorId,
    doctorName,
    medications,
    dosage,
    instructions,
    duration,
    prescribedAt,
    cachedAt,
    isOfflineAccessed,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedPrescription &&
          other.id == this.id &&
          other.appointmentId == this.appointmentId &&
          other.patientId == this.patientId &&
          other.doctorId == this.doctorId &&
          other.doctorName == this.doctorName &&
          other.medications == this.medications &&
          other.dosage == this.dosage &&
          other.instructions == this.instructions &&
          other.duration == this.duration &&
          other.prescribedAt == this.prescribedAt &&
          other.cachedAt == this.cachedAt &&
          other.isOfflineAccessed == this.isOfflineAccessed);
}

class CachedPrescriptionsCompanion extends UpdateCompanion<CachedPrescription> {
  final Value<String> id;
  final Value<String> appointmentId;
  final Value<String> patientId;
  final Value<String> doctorId;
  final Value<String> doctorName;
  final Value<String> medications;
  final Value<String> dosage;
  final Value<String> instructions;
  final Value<String> duration;
  final Value<DateTime> prescribedAt;
  final Value<DateTime> cachedAt;
  final Value<bool> isOfflineAccessed;
  final Value<int> rowid;
  const CachedPrescriptionsCompanion({
    this.id = const Value.absent(),
    this.appointmentId = const Value.absent(),
    this.patientId = const Value.absent(),
    this.doctorId = const Value.absent(),
    this.doctorName = const Value.absent(),
    this.medications = const Value.absent(),
    this.dosage = const Value.absent(),
    this.instructions = const Value.absent(),
    this.duration = const Value.absent(),
    this.prescribedAt = const Value.absent(),
    this.cachedAt = const Value.absent(),
    this.isOfflineAccessed = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedPrescriptionsCompanion.insert({
    required String id,
    required String appointmentId,
    required String patientId,
    required String doctorId,
    required String doctorName,
    required String medications,
    required String dosage,
    required String instructions,
    required String duration,
    required DateTime prescribedAt,
    required DateTime cachedAt,
    this.isOfflineAccessed = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       appointmentId = Value(appointmentId),
       patientId = Value(patientId),
       doctorId = Value(doctorId),
       doctorName = Value(doctorName),
       medications = Value(medications),
       dosage = Value(dosage),
       instructions = Value(instructions),
       duration = Value(duration),
       prescribedAt = Value(prescribedAt),
       cachedAt = Value(cachedAt);
  static Insertable<CachedPrescription> custom({
    Expression<String>? id,
    Expression<String>? appointmentId,
    Expression<String>? patientId,
    Expression<String>? doctorId,
    Expression<String>? doctorName,
    Expression<String>? medications,
    Expression<String>? dosage,
    Expression<String>? instructions,
    Expression<String>? duration,
    Expression<DateTime>? prescribedAt,
    Expression<DateTime>? cachedAt,
    Expression<bool>? isOfflineAccessed,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (appointmentId != null) 'appointment_id': appointmentId,
      if (patientId != null) 'patient_id': patientId,
      if (doctorId != null) 'doctor_id': doctorId,
      if (doctorName != null) 'doctor_name': doctorName,
      if (medications != null) 'medications': medications,
      if (dosage != null) 'dosage': dosage,
      if (instructions != null) 'instructions': instructions,
      if (duration != null) 'duration': duration,
      if (prescribedAt != null) 'prescribed_at': prescribedAt,
      if (cachedAt != null) 'cached_at': cachedAt,
      if (isOfflineAccessed != null) 'is_offline_accessed': isOfflineAccessed,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedPrescriptionsCompanion copyWith({
    Value<String>? id,
    Value<String>? appointmentId,
    Value<String>? patientId,
    Value<String>? doctorId,
    Value<String>? doctorName,
    Value<String>? medications,
    Value<String>? dosage,
    Value<String>? instructions,
    Value<String>? duration,
    Value<DateTime>? prescribedAt,
    Value<DateTime>? cachedAt,
    Value<bool>? isOfflineAccessed,
    Value<int>? rowid,
  }) {
    return CachedPrescriptionsCompanion(
      id: id ?? this.id,
      appointmentId: appointmentId ?? this.appointmentId,
      patientId: patientId ?? this.patientId,
      doctorId: doctorId ?? this.doctorId,
      doctorName: doctorName ?? this.doctorName,
      medications: medications ?? this.medications,
      dosage: dosage ?? this.dosage,
      instructions: instructions ?? this.instructions,
      duration: duration ?? this.duration,
      prescribedAt: prescribedAt ?? this.prescribedAt,
      cachedAt: cachedAt ?? this.cachedAt,
      isOfflineAccessed: isOfflineAccessed ?? this.isOfflineAccessed,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (appointmentId.present) {
      map['appointment_id'] = Variable<String>(appointmentId.value);
    }
    if (patientId.present) {
      map['patient_id'] = Variable<String>(patientId.value);
    }
    if (doctorId.present) {
      map['doctor_id'] = Variable<String>(doctorId.value);
    }
    if (doctorName.present) {
      map['doctor_name'] = Variable<String>(doctorName.value);
    }
    if (medications.present) {
      map['medications'] = Variable<String>(medications.value);
    }
    if (dosage.present) {
      map['dosage'] = Variable<String>(dosage.value);
    }
    if (instructions.present) {
      map['instructions'] = Variable<String>(instructions.value);
    }
    if (duration.present) {
      map['duration'] = Variable<String>(duration.value);
    }
    if (prescribedAt.present) {
      map['prescribed_at'] = Variable<DateTime>(prescribedAt.value);
    }
    if (cachedAt.present) {
      map['cached_at'] = Variable<DateTime>(cachedAt.value);
    }
    if (isOfflineAccessed.present) {
      map['is_offline_accessed'] = Variable<bool>(isOfflineAccessed.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedPrescriptionsCompanion(')
          ..write('id: $id, ')
          ..write('appointmentId: $appointmentId, ')
          ..write('patientId: $patientId, ')
          ..write('doctorId: $doctorId, ')
          ..write('doctorName: $doctorName, ')
          ..write('medications: $medications, ')
          ..write('dosage: $dosage, ')
          ..write('instructions: $instructions, ')
          ..write('duration: $duration, ')
          ..write('prescribedAt: $prescribedAt, ')
          ..write('cachedAt: $cachedAt, ')
          ..write('isOfflineAccessed: $isOfflineAccessed, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OfflineSymptomChecksTable extends OfflineSymptomChecks
    with TableInfo<$OfflineSymptomChecksTable, OfflineSymptomCheck> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OfflineSymptomChecksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _patientIdMeta = const VerificationMeta(
    'patientId',
  );
  @override
  late final GeneratedColumn<String> patientId = GeneratedColumn<String>(
    'patient_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _symptomsMeta = const VerificationMeta(
    'symptoms',
  );
  @override
  late final GeneratedColumn<String> symptoms = GeneratedColumn<String>(
    'symptoms',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _severityMeta = const VerificationMeta(
    'severity',
  );
  @override
  late final GeneratedColumn<String> severity = GeneratedColumn<String>(
    'severity',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recommendationsMeta = const VerificationMeta(
    'recommendations',
  );
  @override
  late final GeneratedColumn<String> recommendations = GeneratedColumn<String>(
    'recommendations',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _languageMeta = const VerificationMeta(
    'language',
  );
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
    'language',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('en'),
  );
  static const VerificationMeta _checkedAtMeta = const VerificationMeta(
    'checkedAt',
  );
  @override
  late final GeneratedColumn<DateTime> checkedAt = GeneratedColumn<DateTime>(
    'checked_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _requiresUrgentCareMeta =
      const VerificationMeta('requiresUrgentCare');
  @override
  late final GeneratedColumn<bool> requiresUrgentCare = GeneratedColumn<bool>(
    'requires_urgent_care',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("requires_urgent_care" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    patientId,
    symptoms,
    severity,
    recommendations,
    language,
    checkedAt,
    requiresUrgentCare,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'offline_symptom_checks';
  @override
  VerificationContext validateIntegrity(
    Insertable<OfflineSymptomCheck> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('patient_id')) {
      context.handle(
        _patientIdMeta,
        patientId.isAcceptableOrUnknown(data['patient_id']!, _patientIdMeta),
      );
    } else if (isInserting) {
      context.missing(_patientIdMeta);
    }
    if (data.containsKey('symptoms')) {
      context.handle(
        _symptomsMeta,
        symptoms.isAcceptableOrUnknown(data['symptoms']!, _symptomsMeta),
      );
    } else if (isInserting) {
      context.missing(_symptomsMeta);
    }
    if (data.containsKey('severity')) {
      context.handle(
        _severityMeta,
        severity.isAcceptableOrUnknown(data['severity']!, _severityMeta),
      );
    } else if (isInserting) {
      context.missing(_severityMeta);
    }
    if (data.containsKey('recommendations')) {
      context.handle(
        _recommendationsMeta,
        recommendations.isAcceptableOrUnknown(
          data['recommendations']!,
          _recommendationsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_recommendationsMeta);
    }
    if (data.containsKey('language')) {
      context.handle(
        _languageMeta,
        language.isAcceptableOrUnknown(data['language']!, _languageMeta),
      );
    }
    if (data.containsKey('checked_at')) {
      context.handle(
        _checkedAtMeta,
        checkedAt.isAcceptableOrUnknown(data['checked_at']!, _checkedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_checkedAtMeta);
    }
    if (data.containsKey('requires_urgent_care')) {
      context.handle(
        _requiresUrgentCareMeta,
        requiresUrgentCare.isAcceptableOrUnknown(
          data['requires_urgent_care']!,
          _requiresUrgentCareMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OfflineSymptomCheck map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OfflineSymptomCheck(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      patientId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}patient_id'],
      )!,
      symptoms: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}symptoms'],
      )!,
      severity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}severity'],
      )!,
      recommendations: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recommendations'],
      )!,
      language: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}language'],
      )!,
      checkedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}checked_at'],
      )!,
      requiresUrgentCare: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}requires_urgent_care'],
      )!,
    );
  }

  @override
  $OfflineSymptomChecksTable createAlias(String alias) {
    return $OfflineSymptomChecksTable(attachedDatabase, alias);
  }
}

class OfflineSymptomCheck extends DataClass
    implements Insertable<OfflineSymptomCheck> {
  final String id;
  final String patientId;
  final String symptoms;
  final String severity;
  final String recommendations;
  final String language;
  final DateTime checkedAt;
  final bool requiresUrgentCare;
  const OfflineSymptomCheck({
    required this.id,
    required this.patientId,
    required this.symptoms,
    required this.severity,
    required this.recommendations,
    required this.language,
    required this.checkedAt,
    required this.requiresUrgentCare,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['patient_id'] = Variable<String>(patientId);
    map['symptoms'] = Variable<String>(symptoms);
    map['severity'] = Variable<String>(severity);
    map['recommendations'] = Variable<String>(recommendations);
    map['language'] = Variable<String>(language);
    map['checked_at'] = Variable<DateTime>(checkedAt);
    map['requires_urgent_care'] = Variable<bool>(requiresUrgentCare);
    return map;
  }

  OfflineSymptomChecksCompanion toCompanion(bool nullToAbsent) {
    return OfflineSymptomChecksCompanion(
      id: Value(id),
      patientId: Value(patientId),
      symptoms: Value(symptoms),
      severity: Value(severity),
      recommendations: Value(recommendations),
      language: Value(language),
      checkedAt: Value(checkedAt),
      requiresUrgentCare: Value(requiresUrgentCare),
    );
  }

  factory OfflineSymptomCheck.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OfflineSymptomCheck(
      id: serializer.fromJson<String>(json['id']),
      patientId: serializer.fromJson<String>(json['patientId']),
      symptoms: serializer.fromJson<String>(json['symptoms']),
      severity: serializer.fromJson<String>(json['severity']),
      recommendations: serializer.fromJson<String>(json['recommendations']),
      language: serializer.fromJson<String>(json['language']),
      checkedAt: serializer.fromJson<DateTime>(json['checkedAt']),
      requiresUrgentCare: serializer.fromJson<bool>(json['requiresUrgentCare']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'patientId': serializer.toJson<String>(patientId),
      'symptoms': serializer.toJson<String>(symptoms),
      'severity': serializer.toJson<String>(severity),
      'recommendations': serializer.toJson<String>(recommendations),
      'language': serializer.toJson<String>(language),
      'checkedAt': serializer.toJson<DateTime>(checkedAt),
      'requiresUrgentCare': serializer.toJson<bool>(requiresUrgentCare),
    };
  }

  OfflineSymptomCheck copyWith({
    String? id,
    String? patientId,
    String? symptoms,
    String? severity,
    String? recommendations,
    String? language,
    DateTime? checkedAt,
    bool? requiresUrgentCare,
  }) => OfflineSymptomCheck(
    id: id ?? this.id,
    patientId: patientId ?? this.patientId,
    symptoms: symptoms ?? this.symptoms,
    severity: severity ?? this.severity,
    recommendations: recommendations ?? this.recommendations,
    language: language ?? this.language,
    checkedAt: checkedAt ?? this.checkedAt,
    requiresUrgentCare: requiresUrgentCare ?? this.requiresUrgentCare,
  );
  OfflineSymptomCheck copyWithCompanion(OfflineSymptomChecksCompanion data) {
    return OfflineSymptomCheck(
      id: data.id.present ? data.id.value : this.id,
      patientId: data.patientId.present ? data.patientId.value : this.patientId,
      symptoms: data.symptoms.present ? data.symptoms.value : this.symptoms,
      severity: data.severity.present ? data.severity.value : this.severity,
      recommendations: data.recommendations.present
          ? data.recommendations.value
          : this.recommendations,
      language: data.language.present ? data.language.value : this.language,
      checkedAt: data.checkedAt.present ? data.checkedAt.value : this.checkedAt,
      requiresUrgentCare: data.requiresUrgentCare.present
          ? data.requiresUrgentCare.value
          : this.requiresUrgentCare,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OfflineSymptomCheck(')
          ..write('id: $id, ')
          ..write('patientId: $patientId, ')
          ..write('symptoms: $symptoms, ')
          ..write('severity: $severity, ')
          ..write('recommendations: $recommendations, ')
          ..write('language: $language, ')
          ..write('checkedAt: $checkedAt, ')
          ..write('requiresUrgentCare: $requiresUrgentCare')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    patientId,
    symptoms,
    severity,
    recommendations,
    language,
    checkedAt,
    requiresUrgentCare,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OfflineSymptomCheck &&
          other.id == this.id &&
          other.patientId == this.patientId &&
          other.symptoms == this.symptoms &&
          other.severity == this.severity &&
          other.recommendations == this.recommendations &&
          other.language == this.language &&
          other.checkedAt == this.checkedAt &&
          other.requiresUrgentCare == this.requiresUrgentCare);
}

class OfflineSymptomChecksCompanion
    extends UpdateCompanion<OfflineSymptomCheck> {
  final Value<String> id;
  final Value<String> patientId;
  final Value<String> symptoms;
  final Value<String> severity;
  final Value<String> recommendations;
  final Value<String> language;
  final Value<DateTime> checkedAt;
  final Value<bool> requiresUrgentCare;
  final Value<int> rowid;
  const OfflineSymptomChecksCompanion({
    this.id = const Value.absent(),
    this.patientId = const Value.absent(),
    this.symptoms = const Value.absent(),
    this.severity = const Value.absent(),
    this.recommendations = const Value.absent(),
    this.language = const Value.absent(),
    this.checkedAt = const Value.absent(),
    this.requiresUrgentCare = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OfflineSymptomChecksCompanion.insert({
    required String id,
    required String patientId,
    required String symptoms,
    required String severity,
    required String recommendations,
    this.language = const Value.absent(),
    required DateTime checkedAt,
    this.requiresUrgentCare = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       patientId = Value(patientId),
       symptoms = Value(symptoms),
       severity = Value(severity),
       recommendations = Value(recommendations),
       checkedAt = Value(checkedAt);
  static Insertable<OfflineSymptomCheck> custom({
    Expression<String>? id,
    Expression<String>? patientId,
    Expression<String>? symptoms,
    Expression<String>? severity,
    Expression<String>? recommendations,
    Expression<String>? language,
    Expression<DateTime>? checkedAt,
    Expression<bool>? requiresUrgentCare,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (patientId != null) 'patient_id': patientId,
      if (symptoms != null) 'symptoms': symptoms,
      if (severity != null) 'severity': severity,
      if (recommendations != null) 'recommendations': recommendations,
      if (language != null) 'language': language,
      if (checkedAt != null) 'checked_at': checkedAt,
      if (requiresUrgentCare != null)
        'requires_urgent_care': requiresUrgentCare,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OfflineSymptomChecksCompanion copyWith({
    Value<String>? id,
    Value<String>? patientId,
    Value<String>? symptoms,
    Value<String>? severity,
    Value<String>? recommendations,
    Value<String>? language,
    Value<DateTime>? checkedAt,
    Value<bool>? requiresUrgentCare,
    Value<int>? rowid,
  }) {
    return OfflineSymptomChecksCompanion(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      symptoms: symptoms ?? this.symptoms,
      severity: severity ?? this.severity,
      recommendations: recommendations ?? this.recommendations,
      language: language ?? this.language,
      checkedAt: checkedAt ?? this.checkedAt,
      requiresUrgentCare: requiresUrgentCare ?? this.requiresUrgentCare,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (patientId.present) {
      map['patient_id'] = Variable<String>(patientId.value);
    }
    if (symptoms.present) {
      map['symptoms'] = Variable<String>(symptoms.value);
    }
    if (severity.present) {
      map['severity'] = Variable<String>(severity.value);
    }
    if (recommendations.present) {
      map['recommendations'] = Variable<String>(recommendations.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (checkedAt.present) {
      map['checked_at'] = Variable<DateTime>(checkedAt.value);
    }
    if (requiresUrgentCare.present) {
      map['requires_urgent_care'] = Variable<bool>(requiresUrgentCare.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OfflineSymptomChecksCompanion(')
          ..write('id: $id, ')
          ..write('patientId: $patientId, ')
          ..write('symptoms: $symptoms, ')
          ..write('severity: $severity, ')
          ..write('recommendations: $recommendations, ')
          ..write('language: $language, ')
          ..write('checkedAt: $checkedAt, ')
          ..write('requiresUrgentCare: $requiresUrgentCare, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncQueuesTable extends SyncQueues
    with TableInfo<$SyncQueuesTable, SyncQueue> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncQueuesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetTableMeta = const VerificationMeta(
    'targetTable',
  );
  @override
  late final GeneratedColumn<String> targetTable = GeneratedColumn<String>(
    'target_table',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recordIdMeta = const VerificationMeta(
    'recordId',
  );
  @override
  late final GeneratedColumn<String> recordId = GeneratedColumn<String>(
    'record_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _operationMeta = const VerificationMeta(
    'operation',
  );
  @override
  late final GeneratedColumn<String> operation = GeneratedColumn<String>(
    'operation',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dataMeta = const VerificationMeta('data');
  @override
  late final GeneratedColumn<String> data = GeneratedColumn<String>(
    'data',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _priorityMeta = const VerificationMeta(
    'priority',
  );
  @override
  late final GeneratedColumn<int> priority = GeneratedColumn<int>(
    'priority',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _retryCountMeta = const VerificationMeta(
    'retryCount',
  );
  @override
  late final GeneratedColumn<int> retryCount = GeneratedColumn<int>(
    'retry_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastAttemptMeta = const VerificationMeta(
    'lastAttempt',
  );
  @override
  late final GeneratedColumn<DateTime> lastAttempt = GeneratedColumn<DateTime>(
    'last_attempt',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    targetTable,
    recordId,
    operation,
    data,
    priority,
    createdAt,
    retryCount,
    lastAttempt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_queues';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncQueue> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('target_table')) {
      context.handle(
        _targetTableMeta,
        targetTable.isAcceptableOrUnknown(
          data['target_table']!,
          _targetTableMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_targetTableMeta);
    }
    if (data.containsKey('record_id')) {
      context.handle(
        _recordIdMeta,
        recordId.isAcceptableOrUnknown(data['record_id']!, _recordIdMeta),
      );
    } else if (isInserting) {
      context.missing(_recordIdMeta);
    }
    if (data.containsKey('operation')) {
      context.handle(
        _operationMeta,
        operation.isAcceptableOrUnknown(data['operation']!, _operationMeta),
      );
    } else if (isInserting) {
      context.missing(_operationMeta);
    }
    if (data.containsKey('data')) {
      context.handle(
        _dataMeta,
        this.data.isAcceptableOrUnknown(data['data']!, _dataMeta),
      );
    } else if (isInserting) {
      context.missing(_dataMeta);
    }
    if (data.containsKey('priority')) {
      context.handle(
        _priorityMeta,
        priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('retry_count')) {
      context.handle(
        _retryCountMeta,
        retryCount.isAcceptableOrUnknown(data['retry_count']!, _retryCountMeta),
      );
    }
    if (data.containsKey('last_attempt')) {
      context.handle(
        _lastAttemptMeta,
        lastAttempt.isAcceptableOrUnknown(
          data['last_attempt']!,
          _lastAttemptMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncQueue map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncQueue(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      targetTable: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_table'],
      )!,
      recordId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}record_id'],
      )!,
      operation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}operation'],
      )!,
      data: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}data'],
      )!,
      priority: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}priority'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      retryCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}retry_count'],
      )!,
      lastAttempt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_attempt'],
      ),
    );
  }

  @override
  $SyncQueuesTable createAlias(String alias) {
    return $SyncQueuesTable(attachedDatabase, alias);
  }
}

class SyncQueue extends DataClass implements Insertable<SyncQueue> {
  final String id;
  final String targetTable;
  final String recordId;
  final String operation;
  final String data;
  final int priority;
  final DateTime createdAt;
  final int retryCount;
  final DateTime? lastAttempt;
  const SyncQueue({
    required this.id,
    required this.targetTable,
    required this.recordId,
    required this.operation,
    required this.data,
    required this.priority,
    required this.createdAt,
    required this.retryCount,
    this.lastAttempt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['target_table'] = Variable<String>(targetTable);
    map['record_id'] = Variable<String>(recordId);
    map['operation'] = Variable<String>(operation);
    map['data'] = Variable<String>(data);
    map['priority'] = Variable<int>(priority);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['retry_count'] = Variable<int>(retryCount);
    if (!nullToAbsent || lastAttempt != null) {
      map['last_attempt'] = Variable<DateTime>(lastAttempt);
    }
    return map;
  }

  SyncQueuesCompanion toCompanion(bool nullToAbsent) {
    return SyncQueuesCompanion(
      id: Value(id),
      targetTable: Value(targetTable),
      recordId: Value(recordId),
      operation: Value(operation),
      data: Value(data),
      priority: Value(priority),
      createdAt: Value(createdAt),
      retryCount: Value(retryCount),
      lastAttempt: lastAttempt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastAttempt),
    );
  }

  factory SyncQueue.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncQueue(
      id: serializer.fromJson<String>(json['id']),
      targetTable: serializer.fromJson<String>(json['targetTable']),
      recordId: serializer.fromJson<String>(json['recordId']),
      operation: serializer.fromJson<String>(json['operation']),
      data: serializer.fromJson<String>(json['data']),
      priority: serializer.fromJson<int>(json['priority']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      retryCount: serializer.fromJson<int>(json['retryCount']),
      lastAttempt: serializer.fromJson<DateTime?>(json['lastAttempt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'targetTable': serializer.toJson<String>(targetTable),
      'recordId': serializer.toJson<String>(recordId),
      'operation': serializer.toJson<String>(operation),
      'data': serializer.toJson<String>(data),
      'priority': serializer.toJson<int>(priority),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'retryCount': serializer.toJson<int>(retryCount),
      'lastAttempt': serializer.toJson<DateTime?>(lastAttempt),
    };
  }

  SyncQueue copyWith({
    String? id,
    String? targetTable,
    String? recordId,
    String? operation,
    String? data,
    int? priority,
    DateTime? createdAt,
    int? retryCount,
    Value<DateTime?> lastAttempt = const Value.absent(),
  }) => SyncQueue(
    id: id ?? this.id,
    targetTable: targetTable ?? this.targetTable,
    recordId: recordId ?? this.recordId,
    operation: operation ?? this.operation,
    data: data ?? this.data,
    priority: priority ?? this.priority,
    createdAt: createdAt ?? this.createdAt,
    retryCount: retryCount ?? this.retryCount,
    lastAttempt: lastAttempt.present ? lastAttempt.value : this.lastAttempt,
  );
  SyncQueue copyWithCompanion(SyncQueuesCompanion data) {
    return SyncQueue(
      id: data.id.present ? data.id.value : this.id,
      targetTable: data.targetTable.present
          ? data.targetTable.value
          : this.targetTable,
      recordId: data.recordId.present ? data.recordId.value : this.recordId,
      operation: data.operation.present ? data.operation.value : this.operation,
      data: data.data.present ? data.data.value : this.data,
      priority: data.priority.present ? data.priority.value : this.priority,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      retryCount: data.retryCount.present
          ? data.retryCount.value
          : this.retryCount,
      lastAttempt: data.lastAttempt.present
          ? data.lastAttempt.value
          : this.lastAttempt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueue(')
          ..write('id: $id, ')
          ..write('targetTable: $targetTable, ')
          ..write('recordId: $recordId, ')
          ..write('operation: $operation, ')
          ..write('data: $data, ')
          ..write('priority: $priority, ')
          ..write('createdAt: $createdAt, ')
          ..write('retryCount: $retryCount, ')
          ..write('lastAttempt: $lastAttempt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    targetTable,
    recordId,
    operation,
    data,
    priority,
    createdAt,
    retryCount,
    lastAttempt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncQueue &&
          other.id == this.id &&
          other.targetTable == this.targetTable &&
          other.recordId == this.recordId &&
          other.operation == this.operation &&
          other.data == this.data &&
          other.priority == this.priority &&
          other.createdAt == this.createdAt &&
          other.retryCount == this.retryCount &&
          other.lastAttempt == this.lastAttempt);
}

class SyncQueuesCompanion extends UpdateCompanion<SyncQueue> {
  final Value<String> id;
  final Value<String> targetTable;
  final Value<String> recordId;
  final Value<String> operation;
  final Value<String> data;
  final Value<int> priority;
  final Value<DateTime> createdAt;
  final Value<int> retryCount;
  final Value<DateTime?> lastAttempt;
  final Value<int> rowid;
  const SyncQueuesCompanion({
    this.id = const Value.absent(),
    this.targetTable = const Value.absent(),
    this.recordId = const Value.absent(),
    this.operation = const Value.absent(),
    this.data = const Value.absent(),
    this.priority = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.lastAttempt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncQueuesCompanion.insert({
    required String id,
    required String targetTable,
    required String recordId,
    required String operation,
    required String data,
    this.priority = const Value.absent(),
    required DateTime createdAt,
    this.retryCount = const Value.absent(),
    this.lastAttempt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       targetTable = Value(targetTable),
       recordId = Value(recordId),
       operation = Value(operation),
       data = Value(data),
       createdAt = Value(createdAt);
  static Insertable<SyncQueue> custom({
    Expression<String>? id,
    Expression<String>? targetTable,
    Expression<String>? recordId,
    Expression<String>? operation,
    Expression<String>? data,
    Expression<int>? priority,
    Expression<DateTime>? createdAt,
    Expression<int>? retryCount,
    Expression<DateTime>? lastAttempt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (targetTable != null) 'target_table': targetTable,
      if (recordId != null) 'record_id': recordId,
      if (operation != null) 'operation': operation,
      if (data != null) 'data': data,
      if (priority != null) 'priority': priority,
      if (createdAt != null) 'created_at': createdAt,
      if (retryCount != null) 'retry_count': retryCount,
      if (lastAttempt != null) 'last_attempt': lastAttempt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncQueuesCompanion copyWith({
    Value<String>? id,
    Value<String>? targetTable,
    Value<String>? recordId,
    Value<String>? operation,
    Value<String>? data,
    Value<int>? priority,
    Value<DateTime>? createdAt,
    Value<int>? retryCount,
    Value<DateTime?>? lastAttempt,
    Value<int>? rowid,
  }) {
    return SyncQueuesCompanion(
      id: id ?? this.id,
      targetTable: targetTable ?? this.targetTable,
      recordId: recordId ?? this.recordId,
      operation: operation ?? this.operation,
      data: data ?? this.data,
      priority: priority ?? this.priority,
      createdAt: createdAt ?? this.createdAt,
      retryCount: retryCount ?? this.retryCount,
      lastAttempt: lastAttempt ?? this.lastAttempt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (targetTable.present) {
      map['target_table'] = Variable<String>(targetTable.value);
    }
    if (recordId.present) {
      map['record_id'] = Variable<String>(recordId.value);
    }
    if (operation.present) {
      map['operation'] = Variable<String>(operation.value);
    }
    if (data.present) {
      map['data'] = Variable<String>(data.value);
    }
    if (priority.present) {
      map['priority'] = Variable<int>(priority.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (retryCount.present) {
      map['retry_count'] = Variable<int>(retryCount.value);
    }
    if (lastAttempt.present) {
      map['last_attempt'] = Variable<DateTime>(lastAttempt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueuesCompanion(')
          ..write('id: $id, ')
          ..write('targetTable: $targetTable, ')
          ..write('recordId: $recordId, ')
          ..write('operation: $operation, ')
          ..write('data: $data, ')
          ..write('priority: $priority, ')
          ..write('createdAt: $createdAt, ')
          ..write('retryCount: $retryCount, ')
          ..write('lastAttempt: $lastAttempt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MedicalReportsTable extends MedicalReports
    with TableInfo<$MedicalReportsTable, MedicalReport> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MedicalReportsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _patientIdMeta = const VerificationMeta(
    'patientId',
  );
  @override
  late final GeneratedColumn<String> patientId = GeneratedColumn<String>(
    'patient_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reportTypeMeta = const VerificationMeta(
    'reportType',
  );
  @override
  late final GeneratedColumn<String> reportType = GeneratedColumn<String>(
    'report_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hospitalNameMeta = const VerificationMeta(
    'hospitalName',
  );
  @override
  late final GeneratedColumn<String> hospitalName = GeneratedColumn<String>(
    'hospital_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _doctorNameMeta = const VerificationMeta(
    'doctorName',
  );
  @override
  late final GeneratedColumn<String> doctorName = GeneratedColumn<String>(
    'doctor_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _doctorSpecializationMeta =
      const VerificationMeta('doctorSpecialization');
  @override
  late final GeneratedColumn<String> doctorSpecialization =
      GeneratedColumn<String>(
        'doctor_specialization',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _reportDateMeta = const VerificationMeta(
    'reportDate',
  );
  @override
  late final GeneratedColumn<DateTime> reportDate = GeneratedColumn<DateTime>(
    'report_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _issuedDateMeta = const VerificationMeta(
    'issuedDate',
  );
  @override
  late final GeneratedColumn<DateTime> issuedDate = GeneratedColumn<DateTime>(
    'issued_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _summaryMeta = const VerificationMeta(
    'summary',
  );
  @override
  late final GeneratedColumn<String> summary = GeneratedColumn<String>(
    'summary',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _findingsMeta = const VerificationMeta(
    'findings',
  );
  @override
  late final GeneratedColumn<String> findings = GeneratedColumn<String>(
    'findings',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recommendationsMeta = const VerificationMeta(
    'recommendations',
  );
  @override
  late final GeneratedColumn<String> recommendations = GeneratedColumn<String>(
    'recommendations',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _testResultsMeta = const VerificationMeta(
    'testResults',
  );
  @override
  late final GeneratedColumn<String> testResults = GeneratedColumn<String>(
    'test_results',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _prescriptionsMeta = const VerificationMeta(
    'prescriptions',
  );
  @override
  late final GeneratedColumn<String> prescriptions = GeneratedColumn<String>(
    'prescriptions',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _severityMeta = const VerificationMeta(
    'severity',
  );
  @override
  late final GeneratedColumn<String> severity = GeneratedColumn<String>(
    'severity',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Normal'),
  );
  static const VerificationMeta _isEmergencyMeta = const VerificationMeta(
    'isEmergency',
  );
  @override
  late final GeneratedColumn<bool> isEmergency = GeneratedColumn<bool>(
    'is_emergency',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_emergency" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _reportUrlMeta = const VerificationMeta(
    'reportUrl',
  );
  @override
  late final GeneratedColumn<String> reportUrl = GeneratedColumn<String>(
    'report_url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _attachmentsMeta = const VerificationMeta(
    'attachments',
  );
  @override
  late final GeneratedColumn<String> attachments = GeneratedColumn<String>(
    'attachments',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _vitalSignsMeta = const VerificationMeta(
    'vitalSigns',
  );
  @override
  late final GeneratedColumn<String> vitalSigns = GeneratedColumn<String>(
    'vital_signs',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Final'),
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    patientId,
    reportType,
    title,
    hospitalName,
    doctorName,
    doctorSpecialization,
    reportDate,
    issuedDate,
    summary,
    findings,
    recommendations,
    testResults,
    prescriptions,
    severity,
    isEmergency,
    reportUrl,
    attachments,
    vitalSigns,
    status,
    isSynced,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'medical_reports';
  @override
  VerificationContext validateIntegrity(
    Insertable<MedicalReport> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('patient_id')) {
      context.handle(
        _patientIdMeta,
        patientId.isAcceptableOrUnknown(data['patient_id']!, _patientIdMeta),
      );
    } else if (isInserting) {
      context.missing(_patientIdMeta);
    }
    if (data.containsKey('report_type')) {
      context.handle(
        _reportTypeMeta,
        reportType.isAcceptableOrUnknown(data['report_type']!, _reportTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_reportTypeMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('hospital_name')) {
      context.handle(
        _hospitalNameMeta,
        hospitalName.isAcceptableOrUnknown(
          data['hospital_name']!,
          _hospitalNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_hospitalNameMeta);
    }
    if (data.containsKey('doctor_name')) {
      context.handle(
        _doctorNameMeta,
        doctorName.isAcceptableOrUnknown(data['doctor_name']!, _doctorNameMeta),
      );
    } else if (isInserting) {
      context.missing(_doctorNameMeta);
    }
    if (data.containsKey('doctor_specialization')) {
      context.handle(
        _doctorSpecializationMeta,
        doctorSpecialization.isAcceptableOrUnknown(
          data['doctor_specialization']!,
          _doctorSpecializationMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_doctorSpecializationMeta);
    }
    if (data.containsKey('report_date')) {
      context.handle(
        _reportDateMeta,
        reportDate.isAcceptableOrUnknown(data['report_date']!, _reportDateMeta),
      );
    } else if (isInserting) {
      context.missing(_reportDateMeta);
    }
    if (data.containsKey('issued_date')) {
      context.handle(
        _issuedDateMeta,
        issuedDate.isAcceptableOrUnknown(data['issued_date']!, _issuedDateMeta),
      );
    } else if (isInserting) {
      context.missing(_issuedDateMeta);
    }
    if (data.containsKey('summary')) {
      context.handle(
        _summaryMeta,
        summary.isAcceptableOrUnknown(data['summary']!, _summaryMeta),
      );
    } else if (isInserting) {
      context.missing(_summaryMeta);
    }
    if (data.containsKey('findings')) {
      context.handle(
        _findingsMeta,
        findings.isAcceptableOrUnknown(data['findings']!, _findingsMeta),
      );
    } else if (isInserting) {
      context.missing(_findingsMeta);
    }
    if (data.containsKey('recommendations')) {
      context.handle(
        _recommendationsMeta,
        recommendations.isAcceptableOrUnknown(
          data['recommendations']!,
          _recommendationsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_recommendationsMeta);
    }
    if (data.containsKey('test_results')) {
      context.handle(
        _testResultsMeta,
        testResults.isAcceptableOrUnknown(
          data['test_results']!,
          _testResultsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_testResultsMeta);
    }
    if (data.containsKey('prescriptions')) {
      context.handle(
        _prescriptionsMeta,
        prescriptions.isAcceptableOrUnknown(
          data['prescriptions']!,
          _prescriptionsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_prescriptionsMeta);
    }
    if (data.containsKey('severity')) {
      context.handle(
        _severityMeta,
        severity.isAcceptableOrUnknown(data['severity']!, _severityMeta),
      );
    }
    if (data.containsKey('is_emergency')) {
      context.handle(
        _isEmergencyMeta,
        isEmergency.isAcceptableOrUnknown(
          data['is_emergency']!,
          _isEmergencyMeta,
        ),
      );
    }
    if (data.containsKey('report_url')) {
      context.handle(
        _reportUrlMeta,
        reportUrl.isAcceptableOrUnknown(data['report_url']!, _reportUrlMeta),
      );
    }
    if (data.containsKey('attachments')) {
      context.handle(
        _attachmentsMeta,
        attachments.isAcceptableOrUnknown(
          data['attachments']!,
          _attachmentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_attachmentsMeta);
    }
    if (data.containsKey('vital_signs')) {
      context.handle(
        _vitalSignsMeta,
        vitalSigns.isAcceptableOrUnknown(data['vital_signs']!, _vitalSignsMeta),
      );
    } else if (isInserting) {
      context.missing(_vitalSignsMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MedicalReport map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MedicalReport(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      patientId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}patient_id'],
      )!,
      reportType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}report_type'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      hospitalName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hospital_name'],
      )!,
      doctorName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}doctor_name'],
      )!,
      doctorSpecialization: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}doctor_specialization'],
      )!,
      reportDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}report_date'],
      )!,
      issuedDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}issued_date'],
      )!,
      summary: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}summary'],
      )!,
      findings: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}findings'],
      )!,
      recommendations: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recommendations'],
      )!,
      testResults: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}test_results'],
      )!,
      prescriptions: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}prescriptions'],
      )!,
      severity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}severity'],
      )!,
      isEmergency: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_emergency'],
      )!,
      reportUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}report_url'],
      )!,
      attachments: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}attachments'],
      )!,
      vitalSigns: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vital_signs'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $MedicalReportsTable createAlias(String alias) {
    return $MedicalReportsTable(attachedDatabase, alias);
  }
}

class MedicalReport extends DataClass implements Insertable<MedicalReport> {
  final String id;
  final String patientId;
  final String reportType;
  final String title;
  final String hospitalName;
  final String doctorName;
  final String doctorSpecialization;
  final DateTime reportDate;
  final DateTime issuedDate;
  final String summary;
  final String findings;
  final String recommendations;
  final String testResults;
  final String prescriptions;
  final String severity;
  final bool isEmergency;
  final String reportUrl;
  final String attachments;
  final String vitalSigns;
  final String status;
  final bool isSynced;
  final DateTime createdAt;
  const MedicalReport({
    required this.id,
    required this.patientId,
    required this.reportType,
    required this.title,
    required this.hospitalName,
    required this.doctorName,
    required this.doctorSpecialization,
    required this.reportDate,
    required this.issuedDate,
    required this.summary,
    required this.findings,
    required this.recommendations,
    required this.testResults,
    required this.prescriptions,
    required this.severity,
    required this.isEmergency,
    required this.reportUrl,
    required this.attachments,
    required this.vitalSigns,
    required this.status,
    required this.isSynced,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['patient_id'] = Variable<String>(patientId);
    map['report_type'] = Variable<String>(reportType);
    map['title'] = Variable<String>(title);
    map['hospital_name'] = Variable<String>(hospitalName);
    map['doctor_name'] = Variable<String>(doctorName);
    map['doctor_specialization'] = Variable<String>(doctorSpecialization);
    map['report_date'] = Variable<DateTime>(reportDate);
    map['issued_date'] = Variable<DateTime>(issuedDate);
    map['summary'] = Variable<String>(summary);
    map['findings'] = Variable<String>(findings);
    map['recommendations'] = Variable<String>(recommendations);
    map['test_results'] = Variable<String>(testResults);
    map['prescriptions'] = Variable<String>(prescriptions);
    map['severity'] = Variable<String>(severity);
    map['is_emergency'] = Variable<bool>(isEmergency);
    map['report_url'] = Variable<String>(reportUrl);
    map['attachments'] = Variable<String>(attachments);
    map['vital_signs'] = Variable<String>(vitalSigns);
    map['status'] = Variable<String>(status);
    map['is_synced'] = Variable<bool>(isSynced);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  MedicalReportsCompanion toCompanion(bool nullToAbsent) {
    return MedicalReportsCompanion(
      id: Value(id),
      patientId: Value(patientId),
      reportType: Value(reportType),
      title: Value(title),
      hospitalName: Value(hospitalName),
      doctorName: Value(doctorName),
      doctorSpecialization: Value(doctorSpecialization),
      reportDate: Value(reportDate),
      issuedDate: Value(issuedDate),
      summary: Value(summary),
      findings: Value(findings),
      recommendations: Value(recommendations),
      testResults: Value(testResults),
      prescriptions: Value(prescriptions),
      severity: Value(severity),
      isEmergency: Value(isEmergency),
      reportUrl: Value(reportUrl),
      attachments: Value(attachments),
      vitalSigns: Value(vitalSigns),
      status: Value(status),
      isSynced: Value(isSynced),
      createdAt: Value(createdAt),
    );
  }

  factory MedicalReport.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MedicalReport(
      id: serializer.fromJson<String>(json['id']),
      patientId: serializer.fromJson<String>(json['patientId']),
      reportType: serializer.fromJson<String>(json['reportType']),
      title: serializer.fromJson<String>(json['title']),
      hospitalName: serializer.fromJson<String>(json['hospitalName']),
      doctorName: serializer.fromJson<String>(json['doctorName']),
      doctorSpecialization: serializer.fromJson<String>(
        json['doctorSpecialization'],
      ),
      reportDate: serializer.fromJson<DateTime>(json['reportDate']),
      issuedDate: serializer.fromJson<DateTime>(json['issuedDate']),
      summary: serializer.fromJson<String>(json['summary']),
      findings: serializer.fromJson<String>(json['findings']),
      recommendations: serializer.fromJson<String>(json['recommendations']),
      testResults: serializer.fromJson<String>(json['testResults']),
      prescriptions: serializer.fromJson<String>(json['prescriptions']),
      severity: serializer.fromJson<String>(json['severity']),
      isEmergency: serializer.fromJson<bool>(json['isEmergency']),
      reportUrl: serializer.fromJson<String>(json['reportUrl']),
      attachments: serializer.fromJson<String>(json['attachments']),
      vitalSigns: serializer.fromJson<String>(json['vitalSigns']),
      status: serializer.fromJson<String>(json['status']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'patientId': serializer.toJson<String>(patientId),
      'reportType': serializer.toJson<String>(reportType),
      'title': serializer.toJson<String>(title),
      'hospitalName': serializer.toJson<String>(hospitalName),
      'doctorName': serializer.toJson<String>(doctorName),
      'doctorSpecialization': serializer.toJson<String>(doctorSpecialization),
      'reportDate': serializer.toJson<DateTime>(reportDate),
      'issuedDate': serializer.toJson<DateTime>(issuedDate),
      'summary': serializer.toJson<String>(summary),
      'findings': serializer.toJson<String>(findings),
      'recommendations': serializer.toJson<String>(recommendations),
      'testResults': serializer.toJson<String>(testResults),
      'prescriptions': serializer.toJson<String>(prescriptions),
      'severity': serializer.toJson<String>(severity),
      'isEmergency': serializer.toJson<bool>(isEmergency),
      'reportUrl': serializer.toJson<String>(reportUrl),
      'attachments': serializer.toJson<String>(attachments),
      'vitalSigns': serializer.toJson<String>(vitalSigns),
      'status': serializer.toJson<String>(status),
      'isSynced': serializer.toJson<bool>(isSynced),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  MedicalReport copyWith({
    String? id,
    String? patientId,
    String? reportType,
    String? title,
    String? hospitalName,
    String? doctorName,
    String? doctorSpecialization,
    DateTime? reportDate,
    DateTime? issuedDate,
    String? summary,
    String? findings,
    String? recommendations,
    String? testResults,
    String? prescriptions,
    String? severity,
    bool? isEmergency,
    String? reportUrl,
    String? attachments,
    String? vitalSigns,
    String? status,
    bool? isSynced,
    DateTime? createdAt,
  }) => MedicalReport(
    id: id ?? this.id,
    patientId: patientId ?? this.patientId,
    reportType: reportType ?? this.reportType,
    title: title ?? this.title,
    hospitalName: hospitalName ?? this.hospitalName,
    doctorName: doctorName ?? this.doctorName,
    doctorSpecialization: doctorSpecialization ?? this.doctorSpecialization,
    reportDate: reportDate ?? this.reportDate,
    issuedDate: issuedDate ?? this.issuedDate,
    summary: summary ?? this.summary,
    findings: findings ?? this.findings,
    recommendations: recommendations ?? this.recommendations,
    testResults: testResults ?? this.testResults,
    prescriptions: prescriptions ?? this.prescriptions,
    severity: severity ?? this.severity,
    isEmergency: isEmergency ?? this.isEmergency,
    reportUrl: reportUrl ?? this.reportUrl,
    attachments: attachments ?? this.attachments,
    vitalSigns: vitalSigns ?? this.vitalSigns,
    status: status ?? this.status,
    isSynced: isSynced ?? this.isSynced,
    createdAt: createdAt ?? this.createdAt,
  );
  MedicalReport copyWithCompanion(MedicalReportsCompanion data) {
    return MedicalReport(
      id: data.id.present ? data.id.value : this.id,
      patientId: data.patientId.present ? data.patientId.value : this.patientId,
      reportType: data.reportType.present
          ? data.reportType.value
          : this.reportType,
      title: data.title.present ? data.title.value : this.title,
      hospitalName: data.hospitalName.present
          ? data.hospitalName.value
          : this.hospitalName,
      doctorName: data.doctorName.present
          ? data.doctorName.value
          : this.doctorName,
      doctorSpecialization: data.doctorSpecialization.present
          ? data.doctorSpecialization.value
          : this.doctorSpecialization,
      reportDate: data.reportDate.present
          ? data.reportDate.value
          : this.reportDate,
      issuedDate: data.issuedDate.present
          ? data.issuedDate.value
          : this.issuedDate,
      summary: data.summary.present ? data.summary.value : this.summary,
      findings: data.findings.present ? data.findings.value : this.findings,
      recommendations: data.recommendations.present
          ? data.recommendations.value
          : this.recommendations,
      testResults: data.testResults.present
          ? data.testResults.value
          : this.testResults,
      prescriptions: data.prescriptions.present
          ? data.prescriptions.value
          : this.prescriptions,
      severity: data.severity.present ? data.severity.value : this.severity,
      isEmergency: data.isEmergency.present
          ? data.isEmergency.value
          : this.isEmergency,
      reportUrl: data.reportUrl.present ? data.reportUrl.value : this.reportUrl,
      attachments: data.attachments.present
          ? data.attachments.value
          : this.attachments,
      vitalSigns: data.vitalSigns.present
          ? data.vitalSigns.value
          : this.vitalSigns,
      status: data.status.present ? data.status.value : this.status,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MedicalReport(')
          ..write('id: $id, ')
          ..write('patientId: $patientId, ')
          ..write('reportType: $reportType, ')
          ..write('title: $title, ')
          ..write('hospitalName: $hospitalName, ')
          ..write('doctorName: $doctorName, ')
          ..write('doctorSpecialization: $doctorSpecialization, ')
          ..write('reportDate: $reportDate, ')
          ..write('issuedDate: $issuedDate, ')
          ..write('summary: $summary, ')
          ..write('findings: $findings, ')
          ..write('recommendations: $recommendations, ')
          ..write('testResults: $testResults, ')
          ..write('prescriptions: $prescriptions, ')
          ..write('severity: $severity, ')
          ..write('isEmergency: $isEmergency, ')
          ..write('reportUrl: $reportUrl, ')
          ..write('attachments: $attachments, ')
          ..write('vitalSigns: $vitalSigns, ')
          ..write('status: $status, ')
          ..write('isSynced: $isSynced, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    patientId,
    reportType,
    title,
    hospitalName,
    doctorName,
    doctorSpecialization,
    reportDate,
    issuedDate,
    summary,
    findings,
    recommendations,
    testResults,
    prescriptions,
    severity,
    isEmergency,
    reportUrl,
    attachments,
    vitalSigns,
    status,
    isSynced,
    createdAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MedicalReport &&
          other.id == this.id &&
          other.patientId == this.patientId &&
          other.reportType == this.reportType &&
          other.title == this.title &&
          other.hospitalName == this.hospitalName &&
          other.doctorName == this.doctorName &&
          other.doctorSpecialization == this.doctorSpecialization &&
          other.reportDate == this.reportDate &&
          other.issuedDate == this.issuedDate &&
          other.summary == this.summary &&
          other.findings == this.findings &&
          other.recommendations == this.recommendations &&
          other.testResults == this.testResults &&
          other.prescriptions == this.prescriptions &&
          other.severity == this.severity &&
          other.isEmergency == this.isEmergency &&
          other.reportUrl == this.reportUrl &&
          other.attachments == this.attachments &&
          other.vitalSigns == this.vitalSigns &&
          other.status == this.status &&
          other.isSynced == this.isSynced &&
          other.createdAt == this.createdAt);
}

class MedicalReportsCompanion extends UpdateCompanion<MedicalReport> {
  final Value<String> id;
  final Value<String> patientId;
  final Value<String> reportType;
  final Value<String> title;
  final Value<String> hospitalName;
  final Value<String> doctorName;
  final Value<String> doctorSpecialization;
  final Value<DateTime> reportDate;
  final Value<DateTime> issuedDate;
  final Value<String> summary;
  final Value<String> findings;
  final Value<String> recommendations;
  final Value<String> testResults;
  final Value<String> prescriptions;
  final Value<String> severity;
  final Value<bool> isEmergency;
  final Value<String> reportUrl;
  final Value<String> attachments;
  final Value<String> vitalSigns;
  final Value<String> status;
  final Value<bool> isSynced;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const MedicalReportsCompanion({
    this.id = const Value.absent(),
    this.patientId = const Value.absent(),
    this.reportType = const Value.absent(),
    this.title = const Value.absent(),
    this.hospitalName = const Value.absent(),
    this.doctorName = const Value.absent(),
    this.doctorSpecialization = const Value.absent(),
    this.reportDate = const Value.absent(),
    this.issuedDate = const Value.absent(),
    this.summary = const Value.absent(),
    this.findings = const Value.absent(),
    this.recommendations = const Value.absent(),
    this.testResults = const Value.absent(),
    this.prescriptions = const Value.absent(),
    this.severity = const Value.absent(),
    this.isEmergency = const Value.absent(),
    this.reportUrl = const Value.absent(),
    this.attachments = const Value.absent(),
    this.vitalSigns = const Value.absent(),
    this.status = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MedicalReportsCompanion.insert({
    required String id,
    required String patientId,
    required String reportType,
    required String title,
    required String hospitalName,
    required String doctorName,
    required String doctorSpecialization,
    required DateTime reportDate,
    required DateTime issuedDate,
    required String summary,
    required String findings,
    required String recommendations,
    required String testResults,
    required String prescriptions,
    this.severity = const Value.absent(),
    this.isEmergency = const Value.absent(),
    this.reportUrl = const Value.absent(),
    required String attachments,
    required String vitalSigns,
    this.status = const Value.absent(),
    this.isSynced = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       patientId = Value(patientId),
       reportType = Value(reportType),
       title = Value(title),
       hospitalName = Value(hospitalName),
       doctorName = Value(doctorName),
       doctorSpecialization = Value(doctorSpecialization),
       reportDate = Value(reportDate),
       issuedDate = Value(issuedDate),
       summary = Value(summary),
       findings = Value(findings),
       recommendations = Value(recommendations),
       testResults = Value(testResults),
       prescriptions = Value(prescriptions),
       attachments = Value(attachments),
       vitalSigns = Value(vitalSigns),
       createdAt = Value(createdAt);
  static Insertable<MedicalReport> custom({
    Expression<String>? id,
    Expression<String>? patientId,
    Expression<String>? reportType,
    Expression<String>? title,
    Expression<String>? hospitalName,
    Expression<String>? doctorName,
    Expression<String>? doctorSpecialization,
    Expression<DateTime>? reportDate,
    Expression<DateTime>? issuedDate,
    Expression<String>? summary,
    Expression<String>? findings,
    Expression<String>? recommendations,
    Expression<String>? testResults,
    Expression<String>? prescriptions,
    Expression<String>? severity,
    Expression<bool>? isEmergency,
    Expression<String>? reportUrl,
    Expression<String>? attachments,
    Expression<String>? vitalSigns,
    Expression<String>? status,
    Expression<bool>? isSynced,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (patientId != null) 'patient_id': patientId,
      if (reportType != null) 'report_type': reportType,
      if (title != null) 'title': title,
      if (hospitalName != null) 'hospital_name': hospitalName,
      if (doctorName != null) 'doctor_name': doctorName,
      if (doctorSpecialization != null)
        'doctor_specialization': doctorSpecialization,
      if (reportDate != null) 'report_date': reportDate,
      if (issuedDate != null) 'issued_date': issuedDate,
      if (summary != null) 'summary': summary,
      if (findings != null) 'findings': findings,
      if (recommendations != null) 'recommendations': recommendations,
      if (testResults != null) 'test_results': testResults,
      if (prescriptions != null) 'prescriptions': prescriptions,
      if (severity != null) 'severity': severity,
      if (isEmergency != null) 'is_emergency': isEmergency,
      if (reportUrl != null) 'report_url': reportUrl,
      if (attachments != null) 'attachments': attachments,
      if (vitalSigns != null) 'vital_signs': vitalSigns,
      if (status != null) 'status': status,
      if (isSynced != null) 'is_synced': isSynced,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MedicalReportsCompanion copyWith({
    Value<String>? id,
    Value<String>? patientId,
    Value<String>? reportType,
    Value<String>? title,
    Value<String>? hospitalName,
    Value<String>? doctorName,
    Value<String>? doctorSpecialization,
    Value<DateTime>? reportDate,
    Value<DateTime>? issuedDate,
    Value<String>? summary,
    Value<String>? findings,
    Value<String>? recommendations,
    Value<String>? testResults,
    Value<String>? prescriptions,
    Value<String>? severity,
    Value<bool>? isEmergency,
    Value<String>? reportUrl,
    Value<String>? attachments,
    Value<String>? vitalSigns,
    Value<String>? status,
    Value<bool>? isSynced,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return MedicalReportsCompanion(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      reportType: reportType ?? this.reportType,
      title: title ?? this.title,
      hospitalName: hospitalName ?? this.hospitalName,
      doctorName: doctorName ?? this.doctorName,
      doctorSpecialization: doctorSpecialization ?? this.doctorSpecialization,
      reportDate: reportDate ?? this.reportDate,
      issuedDate: issuedDate ?? this.issuedDate,
      summary: summary ?? this.summary,
      findings: findings ?? this.findings,
      recommendations: recommendations ?? this.recommendations,
      testResults: testResults ?? this.testResults,
      prescriptions: prescriptions ?? this.prescriptions,
      severity: severity ?? this.severity,
      isEmergency: isEmergency ?? this.isEmergency,
      reportUrl: reportUrl ?? this.reportUrl,
      attachments: attachments ?? this.attachments,
      vitalSigns: vitalSigns ?? this.vitalSigns,
      status: status ?? this.status,
      isSynced: isSynced ?? this.isSynced,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (patientId.present) {
      map['patient_id'] = Variable<String>(patientId.value);
    }
    if (reportType.present) {
      map['report_type'] = Variable<String>(reportType.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (hospitalName.present) {
      map['hospital_name'] = Variable<String>(hospitalName.value);
    }
    if (doctorName.present) {
      map['doctor_name'] = Variable<String>(doctorName.value);
    }
    if (doctorSpecialization.present) {
      map['doctor_specialization'] = Variable<String>(
        doctorSpecialization.value,
      );
    }
    if (reportDate.present) {
      map['report_date'] = Variable<DateTime>(reportDate.value);
    }
    if (issuedDate.present) {
      map['issued_date'] = Variable<DateTime>(issuedDate.value);
    }
    if (summary.present) {
      map['summary'] = Variable<String>(summary.value);
    }
    if (findings.present) {
      map['findings'] = Variable<String>(findings.value);
    }
    if (recommendations.present) {
      map['recommendations'] = Variable<String>(recommendations.value);
    }
    if (testResults.present) {
      map['test_results'] = Variable<String>(testResults.value);
    }
    if (prescriptions.present) {
      map['prescriptions'] = Variable<String>(prescriptions.value);
    }
    if (severity.present) {
      map['severity'] = Variable<String>(severity.value);
    }
    if (isEmergency.present) {
      map['is_emergency'] = Variable<bool>(isEmergency.value);
    }
    if (reportUrl.present) {
      map['report_url'] = Variable<String>(reportUrl.value);
    }
    if (attachments.present) {
      map['attachments'] = Variable<String>(attachments.value);
    }
    if (vitalSigns.present) {
      map['vital_signs'] = Variable<String>(vitalSigns.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MedicalReportsCompanion(')
          ..write('id: $id, ')
          ..write('patientId: $patientId, ')
          ..write('reportType: $reportType, ')
          ..write('title: $title, ')
          ..write('hospitalName: $hospitalName, ')
          ..write('doctorName: $doctorName, ')
          ..write('doctorSpecialization: $doctorSpecialization, ')
          ..write('reportDate: $reportDate, ')
          ..write('issuedDate: $issuedDate, ')
          ..write('summary: $summary, ')
          ..write('findings: $findings, ')
          ..write('recommendations: $recommendations, ')
          ..write('testResults: $testResults, ')
          ..write('prescriptions: $prescriptions, ')
          ..write('severity: $severity, ')
          ..write('isEmergency: $isEmergency, ')
          ..write('reportUrl: $reportUrl, ')
          ..write('attachments: $attachments, ')
          ..write('vitalSigns: $vitalSigns, ')
          ..write('status: $status, ')
          ..write('isSynced: $isSynced, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $VitalSignsTable extends VitalSigns
    with TableInfo<$VitalSignsTable, VitalSign> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VitalSignsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _patientIdMeta = const VerificationMeta(
    'patientId',
  );
  @override
  late final GeneratedColumn<String> patientId = GeneratedColumn<String>(
    'patient_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recordedDateMeta = const VerificationMeta(
    'recordedDate',
  );
  @override
  late final GeneratedColumn<DateTime> recordedDate = GeneratedColumn<DateTime>(
    'recorded_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bloodPressureSystolicMeta =
      const VerificationMeta('bloodPressureSystolic');
  @override
  late final GeneratedColumn<double> bloodPressureSystolic =
      GeneratedColumn<double>(
        'blood_pressure_systolic',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _bloodPressureDiastolicMeta =
      const VerificationMeta('bloodPressureDiastolic');
  @override
  late final GeneratedColumn<double> bloodPressureDiastolic =
      GeneratedColumn<double>(
        'blood_pressure_diastolic',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _heartRateMeta = const VerificationMeta(
    'heartRate',
  );
  @override
  late final GeneratedColumn<double> heartRate = GeneratedColumn<double>(
    'heart_rate',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _temperatureMeta = const VerificationMeta(
    'temperature',
  );
  @override
  late final GeneratedColumn<double> temperature = GeneratedColumn<double>(
    'temperature',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _respiratoryRateMeta = const VerificationMeta(
    'respiratoryRate',
  );
  @override
  late final GeneratedColumn<double> respiratoryRate = GeneratedColumn<double>(
    'respiratory_rate',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _oxygenSaturationMeta = const VerificationMeta(
    'oxygenSaturation',
  );
  @override
  late final GeneratedColumn<double> oxygenSaturation = GeneratedColumn<double>(
    'oxygen_saturation',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bloodSugarMeta = const VerificationMeta(
    'bloodSugar',
  );
  @override
  late final GeneratedColumn<double> bloodSugar = GeneratedColumn<double>(
    'blood_sugar',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _weightMeta = const VerificationMeta('weight');
  @override
  late final GeneratedColumn<double> weight = GeneratedColumn<double>(
    'weight',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _heightMeta = const VerificationMeta('height');
  @override
  late final GeneratedColumn<double> height = GeneratedColumn<double>(
    'height',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bmiMeta = const VerificationMeta('bmi');
  @override
  late final GeneratedColumn<double> bmi = GeneratedColumn<double>(
    'bmi',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _recordedByMeta = const VerificationMeta(
    'recordedBy',
  );
  @override
  late final GeneratedColumn<String> recordedBy = GeneratedColumn<String>(
    'recorded_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    patientId,
    recordedDate,
    bloodPressureSystolic,
    bloodPressureDiastolic,
    heartRate,
    temperature,
    respiratoryRate,
    oxygenSaturation,
    bloodSugar,
    weight,
    height,
    bmi,
    recordedBy,
    notes,
    isSynced,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vital_signs';
  @override
  VerificationContext validateIntegrity(
    Insertable<VitalSign> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('patient_id')) {
      context.handle(
        _patientIdMeta,
        patientId.isAcceptableOrUnknown(data['patient_id']!, _patientIdMeta),
      );
    } else if (isInserting) {
      context.missing(_patientIdMeta);
    }
    if (data.containsKey('recorded_date')) {
      context.handle(
        _recordedDateMeta,
        recordedDate.isAcceptableOrUnknown(
          data['recorded_date']!,
          _recordedDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_recordedDateMeta);
    }
    if (data.containsKey('blood_pressure_systolic')) {
      context.handle(
        _bloodPressureSystolicMeta,
        bloodPressureSystolic.isAcceptableOrUnknown(
          data['blood_pressure_systolic']!,
          _bloodPressureSystolicMeta,
        ),
      );
    }
    if (data.containsKey('blood_pressure_diastolic')) {
      context.handle(
        _bloodPressureDiastolicMeta,
        bloodPressureDiastolic.isAcceptableOrUnknown(
          data['blood_pressure_diastolic']!,
          _bloodPressureDiastolicMeta,
        ),
      );
    }
    if (data.containsKey('heart_rate')) {
      context.handle(
        _heartRateMeta,
        heartRate.isAcceptableOrUnknown(data['heart_rate']!, _heartRateMeta),
      );
    }
    if (data.containsKey('temperature')) {
      context.handle(
        _temperatureMeta,
        temperature.isAcceptableOrUnknown(
          data['temperature']!,
          _temperatureMeta,
        ),
      );
    }
    if (data.containsKey('respiratory_rate')) {
      context.handle(
        _respiratoryRateMeta,
        respiratoryRate.isAcceptableOrUnknown(
          data['respiratory_rate']!,
          _respiratoryRateMeta,
        ),
      );
    }
    if (data.containsKey('oxygen_saturation')) {
      context.handle(
        _oxygenSaturationMeta,
        oxygenSaturation.isAcceptableOrUnknown(
          data['oxygen_saturation']!,
          _oxygenSaturationMeta,
        ),
      );
    }
    if (data.containsKey('blood_sugar')) {
      context.handle(
        _bloodSugarMeta,
        bloodSugar.isAcceptableOrUnknown(data['blood_sugar']!, _bloodSugarMeta),
      );
    }
    if (data.containsKey('weight')) {
      context.handle(
        _weightMeta,
        weight.isAcceptableOrUnknown(data['weight']!, _weightMeta),
      );
    }
    if (data.containsKey('height')) {
      context.handle(
        _heightMeta,
        height.isAcceptableOrUnknown(data['height']!, _heightMeta),
      );
    }
    if (data.containsKey('bmi')) {
      context.handle(
        _bmiMeta,
        bmi.isAcceptableOrUnknown(data['bmi']!, _bmiMeta),
      );
    }
    if (data.containsKey('recorded_by')) {
      context.handle(
        _recordedByMeta,
        recordedBy.isAcceptableOrUnknown(data['recorded_by']!, _recordedByMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VitalSign map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VitalSign(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      patientId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}patient_id'],
      )!,
      recordedDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}recorded_date'],
      )!,
      bloodPressureSystolic: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}blood_pressure_systolic'],
      ),
      bloodPressureDiastolic: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}blood_pressure_diastolic'],
      ),
      heartRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}heart_rate'],
      ),
      temperature: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}temperature'],
      ),
      respiratoryRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}respiratory_rate'],
      ),
      oxygenSaturation: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}oxygen_saturation'],
      ),
      bloodSugar: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}blood_sugar'],
      ),
      weight: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight'],
      ),
      height: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}height'],
      ),
      bmi: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}bmi'],
      ),
      recordedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recorded_by'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      )!,
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $VitalSignsTable createAlias(String alias) {
    return $VitalSignsTable(attachedDatabase, alias);
  }
}

class VitalSign extends DataClass implements Insertable<VitalSign> {
  final String id;
  final String patientId;
  final DateTime recordedDate;
  final double? bloodPressureSystolic;
  final double? bloodPressureDiastolic;
  final double? heartRate;
  final double? temperature;
  final double? respiratoryRate;
  final double? oxygenSaturation;
  final double? bloodSugar;
  final double? weight;
  final double? height;
  final double? bmi;
  final String recordedBy;
  final String notes;
  final bool isSynced;
  final DateTime createdAt;
  const VitalSign({
    required this.id,
    required this.patientId,
    required this.recordedDate,
    this.bloodPressureSystolic,
    this.bloodPressureDiastolic,
    this.heartRate,
    this.temperature,
    this.respiratoryRate,
    this.oxygenSaturation,
    this.bloodSugar,
    this.weight,
    this.height,
    this.bmi,
    required this.recordedBy,
    required this.notes,
    required this.isSynced,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['patient_id'] = Variable<String>(patientId);
    map['recorded_date'] = Variable<DateTime>(recordedDate);
    if (!nullToAbsent || bloodPressureSystolic != null) {
      map['blood_pressure_systolic'] = Variable<double>(bloodPressureSystolic);
    }
    if (!nullToAbsent || bloodPressureDiastolic != null) {
      map['blood_pressure_diastolic'] = Variable<double>(
        bloodPressureDiastolic,
      );
    }
    if (!nullToAbsent || heartRate != null) {
      map['heart_rate'] = Variable<double>(heartRate);
    }
    if (!nullToAbsent || temperature != null) {
      map['temperature'] = Variable<double>(temperature);
    }
    if (!nullToAbsent || respiratoryRate != null) {
      map['respiratory_rate'] = Variable<double>(respiratoryRate);
    }
    if (!nullToAbsent || oxygenSaturation != null) {
      map['oxygen_saturation'] = Variable<double>(oxygenSaturation);
    }
    if (!nullToAbsent || bloodSugar != null) {
      map['blood_sugar'] = Variable<double>(bloodSugar);
    }
    if (!nullToAbsent || weight != null) {
      map['weight'] = Variable<double>(weight);
    }
    if (!nullToAbsent || height != null) {
      map['height'] = Variable<double>(height);
    }
    if (!nullToAbsent || bmi != null) {
      map['bmi'] = Variable<double>(bmi);
    }
    map['recorded_by'] = Variable<String>(recordedBy);
    map['notes'] = Variable<String>(notes);
    map['is_synced'] = Variable<bool>(isSynced);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  VitalSignsCompanion toCompanion(bool nullToAbsent) {
    return VitalSignsCompanion(
      id: Value(id),
      patientId: Value(patientId),
      recordedDate: Value(recordedDate),
      bloodPressureSystolic: bloodPressureSystolic == null && nullToAbsent
          ? const Value.absent()
          : Value(bloodPressureSystolic),
      bloodPressureDiastolic: bloodPressureDiastolic == null && nullToAbsent
          ? const Value.absent()
          : Value(bloodPressureDiastolic),
      heartRate: heartRate == null && nullToAbsent
          ? const Value.absent()
          : Value(heartRate),
      temperature: temperature == null && nullToAbsent
          ? const Value.absent()
          : Value(temperature),
      respiratoryRate: respiratoryRate == null && nullToAbsent
          ? const Value.absent()
          : Value(respiratoryRate),
      oxygenSaturation: oxygenSaturation == null && nullToAbsent
          ? const Value.absent()
          : Value(oxygenSaturation),
      bloodSugar: bloodSugar == null && nullToAbsent
          ? const Value.absent()
          : Value(bloodSugar),
      weight: weight == null && nullToAbsent
          ? const Value.absent()
          : Value(weight),
      height: height == null && nullToAbsent
          ? const Value.absent()
          : Value(height),
      bmi: bmi == null && nullToAbsent ? const Value.absent() : Value(bmi),
      recordedBy: Value(recordedBy),
      notes: Value(notes),
      isSynced: Value(isSynced),
      createdAt: Value(createdAt),
    );
  }

  factory VitalSign.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VitalSign(
      id: serializer.fromJson<String>(json['id']),
      patientId: serializer.fromJson<String>(json['patientId']),
      recordedDate: serializer.fromJson<DateTime>(json['recordedDate']),
      bloodPressureSystolic: serializer.fromJson<double?>(
        json['bloodPressureSystolic'],
      ),
      bloodPressureDiastolic: serializer.fromJson<double?>(
        json['bloodPressureDiastolic'],
      ),
      heartRate: serializer.fromJson<double?>(json['heartRate']),
      temperature: serializer.fromJson<double?>(json['temperature']),
      respiratoryRate: serializer.fromJson<double?>(json['respiratoryRate']),
      oxygenSaturation: serializer.fromJson<double?>(json['oxygenSaturation']),
      bloodSugar: serializer.fromJson<double?>(json['bloodSugar']),
      weight: serializer.fromJson<double?>(json['weight']),
      height: serializer.fromJson<double?>(json['height']),
      bmi: serializer.fromJson<double?>(json['bmi']),
      recordedBy: serializer.fromJson<String>(json['recordedBy']),
      notes: serializer.fromJson<String>(json['notes']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'patientId': serializer.toJson<String>(patientId),
      'recordedDate': serializer.toJson<DateTime>(recordedDate),
      'bloodPressureSystolic': serializer.toJson<double?>(
        bloodPressureSystolic,
      ),
      'bloodPressureDiastolic': serializer.toJson<double?>(
        bloodPressureDiastolic,
      ),
      'heartRate': serializer.toJson<double?>(heartRate),
      'temperature': serializer.toJson<double?>(temperature),
      'respiratoryRate': serializer.toJson<double?>(respiratoryRate),
      'oxygenSaturation': serializer.toJson<double?>(oxygenSaturation),
      'bloodSugar': serializer.toJson<double?>(bloodSugar),
      'weight': serializer.toJson<double?>(weight),
      'height': serializer.toJson<double?>(height),
      'bmi': serializer.toJson<double?>(bmi),
      'recordedBy': serializer.toJson<String>(recordedBy),
      'notes': serializer.toJson<String>(notes),
      'isSynced': serializer.toJson<bool>(isSynced),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  VitalSign copyWith({
    String? id,
    String? patientId,
    DateTime? recordedDate,
    Value<double?> bloodPressureSystolic = const Value.absent(),
    Value<double?> bloodPressureDiastolic = const Value.absent(),
    Value<double?> heartRate = const Value.absent(),
    Value<double?> temperature = const Value.absent(),
    Value<double?> respiratoryRate = const Value.absent(),
    Value<double?> oxygenSaturation = const Value.absent(),
    Value<double?> bloodSugar = const Value.absent(),
    Value<double?> weight = const Value.absent(),
    Value<double?> height = const Value.absent(),
    Value<double?> bmi = const Value.absent(),
    String? recordedBy,
    String? notes,
    bool? isSynced,
    DateTime? createdAt,
  }) => VitalSign(
    id: id ?? this.id,
    patientId: patientId ?? this.patientId,
    recordedDate: recordedDate ?? this.recordedDate,
    bloodPressureSystolic: bloodPressureSystolic.present
        ? bloodPressureSystolic.value
        : this.bloodPressureSystolic,
    bloodPressureDiastolic: bloodPressureDiastolic.present
        ? bloodPressureDiastolic.value
        : this.bloodPressureDiastolic,
    heartRate: heartRate.present ? heartRate.value : this.heartRate,
    temperature: temperature.present ? temperature.value : this.temperature,
    respiratoryRate: respiratoryRate.present
        ? respiratoryRate.value
        : this.respiratoryRate,
    oxygenSaturation: oxygenSaturation.present
        ? oxygenSaturation.value
        : this.oxygenSaturation,
    bloodSugar: bloodSugar.present ? bloodSugar.value : this.bloodSugar,
    weight: weight.present ? weight.value : this.weight,
    height: height.present ? height.value : this.height,
    bmi: bmi.present ? bmi.value : this.bmi,
    recordedBy: recordedBy ?? this.recordedBy,
    notes: notes ?? this.notes,
    isSynced: isSynced ?? this.isSynced,
    createdAt: createdAt ?? this.createdAt,
  );
  VitalSign copyWithCompanion(VitalSignsCompanion data) {
    return VitalSign(
      id: data.id.present ? data.id.value : this.id,
      patientId: data.patientId.present ? data.patientId.value : this.patientId,
      recordedDate: data.recordedDate.present
          ? data.recordedDate.value
          : this.recordedDate,
      bloodPressureSystolic: data.bloodPressureSystolic.present
          ? data.bloodPressureSystolic.value
          : this.bloodPressureSystolic,
      bloodPressureDiastolic: data.bloodPressureDiastolic.present
          ? data.bloodPressureDiastolic.value
          : this.bloodPressureDiastolic,
      heartRate: data.heartRate.present ? data.heartRate.value : this.heartRate,
      temperature: data.temperature.present
          ? data.temperature.value
          : this.temperature,
      respiratoryRate: data.respiratoryRate.present
          ? data.respiratoryRate.value
          : this.respiratoryRate,
      oxygenSaturation: data.oxygenSaturation.present
          ? data.oxygenSaturation.value
          : this.oxygenSaturation,
      bloodSugar: data.bloodSugar.present
          ? data.bloodSugar.value
          : this.bloodSugar,
      weight: data.weight.present ? data.weight.value : this.weight,
      height: data.height.present ? data.height.value : this.height,
      bmi: data.bmi.present ? data.bmi.value : this.bmi,
      recordedBy: data.recordedBy.present
          ? data.recordedBy.value
          : this.recordedBy,
      notes: data.notes.present ? data.notes.value : this.notes,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VitalSign(')
          ..write('id: $id, ')
          ..write('patientId: $patientId, ')
          ..write('recordedDate: $recordedDate, ')
          ..write('bloodPressureSystolic: $bloodPressureSystolic, ')
          ..write('bloodPressureDiastolic: $bloodPressureDiastolic, ')
          ..write('heartRate: $heartRate, ')
          ..write('temperature: $temperature, ')
          ..write('respiratoryRate: $respiratoryRate, ')
          ..write('oxygenSaturation: $oxygenSaturation, ')
          ..write('bloodSugar: $bloodSugar, ')
          ..write('weight: $weight, ')
          ..write('height: $height, ')
          ..write('bmi: $bmi, ')
          ..write('recordedBy: $recordedBy, ')
          ..write('notes: $notes, ')
          ..write('isSynced: $isSynced, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    patientId,
    recordedDate,
    bloodPressureSystolic,
    bloodPressureDiastolic,
    heartRate,
    temperature,
    respiratoryRate,
    oxygenSaturation,
    bloodSugar,
    weight,
    height,
    bmi,
    recordedBy,
    notes,
    isSynced,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VitalSign &&
          other.id == this.id &&
          other.patientId == this.patientId &&
          other.recordedDate == this.recordedDate &&
          other.bloodPressureSystolic == this.bloodPressureSystolic &&
          other.bloodPressureDiastolic == this.bloodPressureDiastolic &&
          other.heartRate == this.heartRate &&
          other.temperature == this.temperature &&
          other.respiratoryRate == this.respiratoryRate &&
          other.oxygenSaturation == this.oxygenSaturation &&
          other.bloodSugar == this.bloodSugar &&
          other.weight == this.weight &&
          other.height == this.height &&
          other.bmi == this.bmi &&
          other.recordedBy == this.recordedBy &&
          other.notes == this.notes &&
          other.isSynced == this.isSynced &&
          other.createdAt == this.createdAt);
}

class VitalSignsCompanion extends UpdateCompanion<VitalSign> {
  final Value<String> id;
  final Value<String> patientId;
  final Value<DateTime> recordedDate;
  final Value<double?> bloodPressureSystolic;
  final Value<double?> bloodPressureDiastolic;
  final Value<double?> heartRate;
  final Value<double?> temperature;
  final Value<double?> respiratoryRate;
  final Value<double?> oxygenSaturation;
  final Value<double?> bloodSugar;
  final Value<double?> weight;
  final Value<double?> height;
  final Value<double?> bmi;
  final Value<String> recordedBy;
  final Value<String> notes;
  final Value<bool> isSynced;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const VitalSignsCompanion({
    this.id = const Value.absent(),
    this.patientId = const Value.absent(),
    this.recordedDate = const Value.absent(),
    this.bloodPressureSystolic = const Value.absent(),
    this.bloodPressureDiastolic = const Value.absent(),
    this.heartRate = const Value.absent(),
    this.temperature = const Value.absent(),
    this.respiratoryRate = const Value.absent(),
    this.oxygenSaturation = const Value.absent(),
    this.bloodSugar = const Value.absent(),
    this.weight = const Value.absent(),
    this.height = const Value.absent(),
    this.bmi = const Value.absent(),
    this.recordedBy = const Value.absent(),
    this.notes = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VitalSignsCompanion.insert({
    required String id,
    required String patientId,
    required DateTime recordedDate,
    this.bloodPressureSystolic = const Value.absent(),
    this.bloodPressureDiastolic = const Value.absent(),
    this.heartRate = const Value.absent(),
    this.temperature = const Value.absent(),
    this.respiratoryRate = const Value.absent(),
    this.oxygenSaturation = const Value.absent(),
    this.bloodSugar = const Value.absent(),
    this.weight = const Value.absent(),
    this.height = const Value.absent(),
    this.bmi = const Value.absent(),
    this.recordedBy = const Value.absent(),
    this.notes = const Value.absent(),
    this.isSynced = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       patientId = Value(patientId),
       recordedDate = Value(recordedDate),
       createdAt = Value(createdAt);
  static Insertable<VitalSign> custom({
    Expression<String>? id,
    Expression<String>? patientId,
    Expression<DateTime>? recordedDate,
    Expression<double>? bloodPressureSystolic,
    Expression<double>? bloodPressureDiastolic,
    Expression<double>? heartRate,
    Expression<double>? temperature,
    Expression<double>? respiratoryRate,
    Expression<double>? oxygenSaturation,
    Expression<double>? bloodSugar,
    Expression<double>? weight,
    Expression<double>? height,
    Expression<double>? bmi,
    Expression<String>? recordedBy,
    Expression<String>? notes,
    Expression<bool>? isSynced,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (patientId != null) 'patient_id': patientId,
      if (recordedDate != null) 'recorded_date': recordedDate,
      if (bloodPressureSystolic != null)
        'blood_pressure_systolic': bloodPressureSystolic,
      if (bloodPressureDiastolic != null)
        'blood_pressure_diastolic': bloodPressureDiastolic,
      if (heartRate != null) 'heart_rate': heartRate,
      if (temperature != null) 'temperature': temperature,
      if (respiratoryRate != null) 'respiratory_rate': respiratoryRate,
      if (oxygenSaturation != null) 'oxygen_saturation': oxygenSaturation,
      if (bloodSugar != null) 'blood_sugar': bloodSugar,
      if (weight != null) 'weight': weight,
      if (height != null) 'height': height,
      if (bmi != null) 'bmi': bmi,
      if (recordedBy != null) 'recorded_by': recordedBy,
      if (notes != null) 'notes': notes,
      if (isSynced != null) 'is_synced': isSynced,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VitalSignsCompanion copyWith({
    Value<String>? id,
    Value<String>? patientId,
    Value<DateTime>? recordedDate,
    Value<double?>? bloodPressureSystolic,
    Value<double?>? bloodPressureDiastolic,
    Value<double?>? heartRate,
    Value<double?>? temperature,
    Value<double?>? respiratoryRate,
    Value<double?>? oxygenSaturation,
    Value<double?>? bloodSugar,
    Value<double?>? weight,
    Value<double?>? height,
    Value<double?>? bmi,
    Value<String>? recordedBy,
    Value<String>? notes,
    Value<bool>? isSynced,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return VitalSignsCompanion(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      recordedDate: recordedDate ?? this.recordedDate,
      bloodPressureSystolic:
          bloodPressureSystolic ?? this.bloodPressureSystolic,
      bloodPressureDiastolic:
          bloodPressureDiastolic ?? this.bloodPressureDiastolic,
      heartRate: heartRate ?? this.heartRate,
      temperature: temperature ?? this.temperature,
      respiratoryRate: respiratoryRate ?? this.respiratoryRate,
      oxygenSaturation: oxygenSaturation ?? this.oxygenSaturation,
      bloodSugar: bloodSugar ?? this.bloodSugar,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      bmi: bmi ?? this.bmi,
      recordedBy: recordedBy ?? this.recordedBy,
      notes: notes ?? this.notes,
      isSynced: isSynced ?? this.isSynced,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (patientId.present) {
      map['patient_id'] = Variable<String>(patientId.value);
    }
    if (recordedDate.present) {
      map['recorded_date'] = Variable<DateTime>(recordedDate.value);
    }
    if (bloodPressureSystolic.present) {
      map['blood_pressure_systolic'] = Variable<double>(
        bloodPressureSystolic.value,
      );
    }
    if (bloodPressureDiastolic.present) {
      map['blood_pressure_diastolic'] = Variable<double>(
        bloodPressureDiastolic.value,
      );
    }
    if (heartRate.present) {
      map['heart_rate'] = Variable<double>(heartRate.value);
    }
    if (temperature.present) {
      map['temperature'] = Variable<double>(temperature.value);
    }
    if (respiratoryRate.present) {
      map['respiratory_rate'] = Variable<double>(respiratoryRate.value);
    }
    if (oxygenSaturation.present) {
      map['oxygen_saturation'] = Variable<double>(oxygenSaturation.value);
    }
    if (bloodSugar.present) {
      map['blood_sugar'] = Variable<double>(bloodSugar.value);
    }
    if (weight.present) {
      map['weight'] = Variable<double>(weight.value);
    }
    if (height.present) {
      map['height'] = Variable<double>(height.value);
    }
    if (bmi.present) {
      map['bmi'] = Variable<double>(bmi.value);
    }
    if (recordedBy.present) {
      map['recorded_by'] = Variable<String>(recordedBy.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VitalSignsCompanion(')
          ..write('id: $id, ')
          ..write('patientId: $patientId, ')
          ..write('recordedDate: $recordedDate, ')
          ..write('bloodPressureSystolic: $bloodPressureSystolic, ')
          ..write('bloodPressureDiastolic: $bloodPressureDiastolic, ')
          ..write('heartRate: $heartRate, ')
          ..write('temperature: $temperature, ')
          ..write('respiratoryRate: $respiratoryRate, ')
          ..write('oxygenSaturation: $oxygenSaturation, ')
          ..write('bloodSugar: $bloodSugar, ')
          ..write('weight: $weight, ')
          ..write('height: $height, ')
          ..write('bmi: $bmi, ')
          ..write('recordedBy: $recordedBy, ')
          ..write('notes: $notes, ')
          ..write('isSynced: $isSynced, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FamilyMembersTable extends FamilyMembers
    with TableInfo<$FamilyMembersTable, FamilyMember> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FamilyMembersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _familyGroupIdMeta = const VerificationMeta(
    'familyGroupId',
  );
  @override
  late final GeneratedColumn<String> familyGroupId = GeneratedColumn<String>(
    'family_group_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _primaryUserIdMeta = const VerificationMeta(
    'primaryUserId',
  );
  @override
  late final GeneratedColumn<String> primaryUserId = GeneratedColumn<String>(
    'primary_user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _relationshipMeta = const VerificationMeta(
    'relationship',
  );
  @override
  late final GeneratedColumn<String> relationship = GeneratedColumn<String>(
    'relationship',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateOfBirthMeta = const VerificationMeta(
    'dateOfBirth',
  );
  @override
  late final GeneratedColumn<DateTime> dateOfBirth = GeneratedColumn<DateTime>(
    'date_of_birth',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _genderMeta = const VerificationMeta('gender');
  @override
  late final GeneratedColumn<String> gender = GeneratedColumn<String>(
    'gender',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bloodGroupMeta = const VerificationMeta(
    'bloodGroup',
  );
  @override
  late final GeneratedColumn<String> bloodGroup = GeneratedColumn<String>(
    'blood_group',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _phoneNumberMeta = const VerificationMeta(
    'phoneNumber',
  );
  @override
  late final GeneratedColumn<String> phoneNumber = GeneratedColumn<String>(
    'phone_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _allergiesMeta = const VerificationMeta(
    'allergies',
  );
  @override
  late final GeneratedColumn<String> allergies = GeneratedColumn<String>(
    'allergies',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _medicalConditionsMeta = const VerificationMeta(
    'medicalConditions',
  );
  @override
  late final GeneratedColumn<String> medicalConditions =
      GeneratedColumn<String>(
        'medical_conditions',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _medicationsMeta = const VerificationMeta(
    'medications',
  );
  @override
  late final GeneratedColumn<String> medications = GeneratedColumn<String>(
    'medications',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _emergencyContactMeta = const VerificationMeta(
    'emergencyContact',
  );
  @override
  late final GeneratedColumn<String> emergencyContact = GeneratedColumn<String>(
    'emergency_contact',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _hasOwnAccountMeta = const VerificationMeta(
    'hasOwnAccount',
  );
  @override
  late final GeneratedColumn<bool> hasOwnAccount = GeneratedColumn<bool>(
    'has_own_account',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("has_own_account" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _linkedAccountIdMeta = const VerificationMeta(
    'linkedAccountId',
  );
  @override
  late final GeneratedColumn<String> linkedAccountId = GeneratedColumn<String>(
    'linked_account_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _allowIndependentAccessMeta =
      const VerificationMeta('allowIndependentAccess');
  @override
  late final GeneratedColumn<bool> allowIndependentAccess =
      GeneratedColumn<bool>(
        'allow_independent_access',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("allow_independent_access" IN (0, 1))',
        ),
        defaultValue: const Constant(false),
      );
  static const VerificationMeta _caregiverPermissionsMeta =
      const VerificationMeta('caregiverPermissions');
  @override
  late final GeneratedColumn<String> caregiverPermissions =
      GeneratedColumn<String>(
        'caregiver_permissions',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _profileImageUrlMeta = const VerificationMeta(
    'profileImageUrl',
  );
  @override
  late final GeneratedColumn<String> profileImageUrl = GeneratedColumn<String>(
    'profile_image_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastModifiedMeta = const VerificationMeta(
    'lastModified',
  );
  @override
  late final GeneratedColumn<DateTime> lastModified = GeneratedColumn<DateTime>(
    'last_modified',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    familyGroupId,
    primaryUserId,
    name,
    relationship,
    dateOfBirth,
    gender,
    bloodGroup,
    phoneNumber,
    email,
    allergies,
    medicalConditions,
    medications,
    emergencyContact,
    isActive,
    hasOwnAccount,
    linkedAccountId,
    allowIndependentAccess,
    caregiverPermissions,
    profileImageUrl,
    isSynced,
    createdAt,
    lastModified,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'family_members';
  @override
  VerificationContext validateIntegrity(
    Insertable<FamilyMember> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('family_group_id')) {
      context.handle(
        _familyGroupIdMeta,
        familyGroupId.isAcceptableOrUnknown(
          data['family_group_id']!,
          _familyGroupIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_familyGroupIdMeta);
    }
    if (data.containsKey('primary_user_id')) {
      context.handle(
        _primaryUserIdMeta,
        primaryUserId.isAcceptableOrUnknown(
          data['primary_user_id']!,
          _primaryUserIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_primaryUserIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('relationship')) {
      context.handle(
        _relationshipMeta,
        relationship.isAcceptableOrUnknown(
          data['relationship']!,
          _relationshipMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_relationshipMeta);
    }
    if (data.containsKey('date_of_birth')) {
      context.handle(
        _dateOfBirthMeta,
        dateOfBirth.isAcceptableOrUnknown(
          data['date_of_birth']!,
          _dateOfBirthMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dateOfBirthMeta);
    }
    if (data.containsKey('gender')) {
      context.handle(
        _genderMeta,
        gender.isAcceptableOrUnknown(data['gender']!, _genderMeta),
      );
    } else if (isInserting) {
      context.missing(_genderMeta);
    }
    if (data.containsKey('blood_group')) {
      context.handle(
        _bloodGroupMeta,
        bloodGroup.isAcceptableOrUnknown(data['blood_group']!, _bloodGroupMeta),
      );
    }
    if (data.containsKey('phone_number')) {
      context.handle(
        _phoneNumberMeta,
        phoneNumber.isAcceptableOrUnknown(
          data['phone_number']!,
          _phoneNumberMeta,
        ),
      );
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('allergies')) {
      context.handle(
        _allergiesMeta,
        allergies.isAcceptableOrUnknown(data['allergies']!, _allergiesMeta),
      );
    }
    if (data.containsKey('medical_conditions')) {
      context.handle(
        _medicalConditionsMeta,
        medicalConditions.isAcceptableOrUnknown(
          data['medical_conditions']!,
          _medicalConditionsMeta,
        ),
      );
    }
    if (data.containsKey('medications')) {
      context.handle(
        _medicationsMeta,
        medications.isAcceptableOrUnknown(
          data['medications']!,
          _medicationsMeta,
        ),
      );
    }
    if (data.containsKey('emergency_contact')) {
      context.handle(
        _emergencyContactMeta,
        emergencyContact.isAcceptableOrUnknown(
          data['emergency_contact']!,
          _emergencyContactMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('has_own_account')) {
      context.handle(
        _hasOwnAccountMeta,
        hasOwnAccount.isAcceptableOrUnknown(
          data['has_own_account']!,
          _hasOwnAccountMeta,
        ),
      );
    }
    if (data.containsKey('linked_account_id')) {
      context.handle(
        _linkedAccountIdMeta,
        linkedAccountId.isAcceptableOrUnknown(
          data['linked_account_id']!,
          _linkedAccountIdMeta,
        ),
      );
    }
    if (data.containsKey('allow_independent_access')) {
      context.handle(
        _allowIndependentAccessMeta,
        allowIndependentAccess.isAcceptableOrUnknown(
          data['allow_independent_access']!,
          _allowIndependentAccessMeta,
        ),
      );
    }
    if (data.containsKey('caregiver_permissions')) {
      context.handle(
        _caregiverPermissionsMeta,
        caregiverPermissions.isAcceptableOrUnknown(
          data['caregiver_permissions']!,
          _caregiverPermissionsMeta,
        ),
      );
    }
    if (data.containsKey('profile_image_url')) {
      context.handle(
        _profileImageUrlMeta,
        profileImageUrl.isAcceptableOrUnknown(
          data['profile_image_url']!,
          _profileImageUrlMeta,
        ),
      );
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('last_modified')) {
      context.handle(
        _lastModifiedMeta,
        lastModified.isAcceptableOrUnknown(
          data['last_modified']!,
          _lastModifiedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastModifiedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FamilyMember map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FamilyMember(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      familyGroupId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}family_group_id'],
      )!,
      primaryUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}primary_user_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      relationship: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}relationship'],
      )!,
      dateOfBirth: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date_of_birth'],
      )!,
      gender: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gender'],
      )!,
      bloodGroup: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}blood_group'],
      ),
      phoneNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone_number'],
      ),
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
      allergies: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}allergies'],
      ),
      medicalConditions: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}medical_conditions'],
      ),
      medications: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}medications'],
      ),
      emergencyContact: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}emergency_contact'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      hasOwnAccount: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}has_own_account'],
      )!,
      linkedAccountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}linked_account_id'],
      ),
      allowIndependentAccess: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}allow_independent_access'],
      )!,
      caregiverPermissions: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}caregiver_permissions'],
      ),
      profileImageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profile_image_url'],
      ),
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      lastModified: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_modified'],
      )!,
    );
  }

  @override
  $FamilyMembersTable createAlias(String alias) {
    return $FamilyMembersTable(attachedDatabase, alias);
  }
}

class FamilyMember extends DataClass implements Insertable<FamilyMember> {
  final String id;
  final String familyGroupId;
  final String primaryUserId;
  final String name;
  final String relationship;
  final DateTime dateOfBirth;
  final String gender;
  final String? bloodGroup;
  final String? phoneNumber;
  final String? email;
  final String? allergies;
  final String? medicalConditions;
  final String? medications;
  final String? emergencyContact;
  final bool isActive;
  final bool hasOwnAccount;
  final String? linkedAccountId;
  final bool allowIndependentAccess;
  final String? caregiverPermissions;
  final String? profileImageUrl;
  final bool isSynced;
  final DateTime createdAt;
  final DateTime lastModified;
  const FamilyMember({
    required this.id,
    required this.familyGroupId,
    required this.primaryUserId,
    required this.name,
    required this.relationship,
    required this.dateOfBirth,
    required this.gender,
    this.bloodGroup,
    this.phoneNumber,
    this.email,
    this.allergies,
    this.medicalConditions,
    this.medications,
    this.emergencyContact,
    required this.isActive,
    required this.hasOwnAccount,
    this.linkedAccountId,
    required this.allowIndependentAccess,
    this.caregiverPermissions,
    this.profileImageUrl,
    required this.isSynced,
    required this.createdAt,
    required this.lastModified,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['family_group_id'] = Variable<String>(familyGroupId);
    map['primary_user_id'] = Variable<String>(primaryUserId);
    map['name'] = Variable<String>(name);
    map['relationship'] = Variable<String>(relationship);
    map['date_of_birth'] = Variable<DateTime>(dateOfBirth);
    map['gender'] = Variable<String>(gender);
    if (!nullToAbsent || bloodGroup != null) {
      map['blood_group'] = Variable<String>(bloodGroup);
    }
    if (!nullToAbsent || phoneNumber != null) {
      map['phone_number'] = Variable<String>(phoneNumber);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || allergies != null) {
      map['allergies'] = Variable<String>(allergies);
    }
    if (!nullToAbsent || medicalConditions != null) {
      map['medical_conditions'] = Variable<String>(medicalConditions);
    }
    if (!nullToAbsent || medications != null) {
      map['medications'] = Variable<String>(medications);
    }
    if (!nullToAbsent || emergencyContact != null) {
      map['emergency_contact'] = Variable<String>(emergencyContact);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['has_own_account'] = Variable<bool>(hasOwnAccount);
    if (!nullToAbsent || linkedAccountId != null) {
      map['linked_account_id'] = Variable<String>(linkedAccountId);
    }
    map['allow_independent_access'] = Variable<bool>(allowIndependentAccess);
    if (!nullToAbsent || caregiverPermissions != null) {
      map['caregiver_permissions'] = Variable<String>(caregiverPermissions);
    }
    if (!nullToAbsent || profileImageUrl != null) {
      map['profile_image_url'] = Variable<String>(profileImageUrl);
    }
    map['is_synced'] = Variable<bool>(isSynced);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['last_modified'] = Variable<DateTime>(lastModified);
    return map;
  }

  FamilyMembersCompanion toCompanion(bool nullToAbsent) {
    return FamilyMembersCompanion(
      id: Value(id),
      familyGroupId: Value(familyGroupId),
      primaryUserId: Value(primaryUserId),
      name: Value(name),
      relationship: Value(relationship),
      dateOfBirth: Value(dateOfBirth),
      gender: Value(gender),
      bloodGroup: bloodGroup == null && nullToAbsent
          ? const Value.absent()
          : Value(bloodGroup),
      phoneNumber: phoneNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(phoneNumber),
      email: email == null && nullToAbsent
          ? const Value.absent()
          : Value(email),
      allergies: allergies == null && nullToAbsent
          ? const Value.absent()
          : Value(allergies),
      medicalConditions: medicalConditions == null && nullToAbsent
          ? const Value.absent()
          : Value(medicalConditions),
      medications: medications == null && nullToAbsent
          ? const Value.absent()
          : Value(medications),
      emergencyContact: emergencyContact == null && nullToAbsent
          ? const Value.absent()
          : Value(emergencyContact),
      isActive: Value(isActive),
      hasOwnAccount: Value(hasOwnAccount),
      linkedAccountId: linkedAccountId == null && nullToAbsent
          ? const Value.absent()
          : Value(linkedAccountId),
      allowIndependentAccess: Value(allowIndependentAccess),
      caregiverPermissions: caregiverPermissions == null && nullToAbsent
          ? const Value.absent()
          : Value(caregiverPermissions),
      profileImageUrl: profileImageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(profileImageUrl),
      isSynced: Value(isSynced),
      createdAt: Value(createdAt),
      lastModified: Value(lastModified),
    );
  }

  factory FamilyMember.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FamilyMember(
      id: serializer.fromJson<String>(json['id']),
      familyGroupId: serializer.fromJson<String>(json['familyGroupId']),
      primaryUserId: serializer.fromJson<String>(json['primaryUserId']),
      name: serializer.fromJson<String>(json['name']),
      relationship: serializer.fromJson<String>(json['relationship']),
      dateOfBirth: serializer.fromJson<DateTime>(json['dateOfBirth']),
      gender: serializer.fromJson<String>(json['gender']),
      bloodGroup: serializer.fromJson<String?>(json['bloodGroup']),
      phoneNumber: serializer.fromJson<String?>(json['phoneNumber']),
      email: serializer.fromJson<String?>(json['email']),
      allergies: serializer.fromJson<String?>(json['allergies']),
      medicalConditions: serializer.fromJson<String?>(
        json['medicalConditions'],
      ),
      medications: serializer.fromJson<String?>(json['medications']),
      emergencyContact: serializer.fromJson<String?>(json['emergencyContact']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      hasOwnAccount: serializer.fromJson<bool>(json['hasOwnAccount']),
      linkedAccountId: serializer.fromJson<String?>(json['linkedAccountId']),
      allowIndependentAccess: serializer.fromJson<bool>(
        json['allowIndependentAccess'],
      ),
      caregiverPermissions: serializer.fromJson<String?>(
        json['caregiverPermissions'],
      ),
      profileImageUrl: serializer.fromJson<String?>(json['profileImageUrl']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      lastModified: serializer.fromJson<DateTime>(json['lastModified']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'familyGroupId': serializer.toJson<String>(familyGroupId),
      'primaryUserId': serializer.toJson<String>(primaryUserId),
      'name': serializer.toJson<String>(name),
      'relationship': serializer.toJson<String>(relationship),
      'dateOfBirth': serializer.toJson<DateTime>(dateOfBirth),
      'gender': serializer.toJson<String>(gender),
      'bloodGroup': serializer.toJson<String?>(bloodGroup),
      'phoneNumber': serializer.toJson<String?>(phoneNumber),
      'email': serializer.toJson<String?>(email),
      'allergies': serializer.toJson<String?>(allergies),
      'medicalConditions': serializer.toJson<String?>(medicalConditions),
      'medications': serializer.toJson<String?>(medications),
      'emergencyContact': serializer.toJson<String?>(emergencyContact),
      'isActive': serializer.toJson<bool>(isActive),
      'hasOwnAccount': serializer.toJson<bool>(hasOwnAccount),
      'linkedAccountId': serializer.toJson<String?>(linkedAccountId),
      'allowIndependentAccess': serializer.toJson<bool>(allowIndependentAccess),
      'caregiverPermissions': serializer.toJson<String?>(caregiverPermissions),
      'profileImageUrl': serializer.toJson<String?>(profileImageUrl),
      'isSynced': serializer.toJson<bool>(isSynced),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'lastModified': serializer.toJson<DateTime>(lastModified),
    };
  }

  FamilyMember copyWith({
    String? id,
    String? familyGroupId,
    String? primaryUserId,
    String? name,
    String? relationship,
    DateTime? dateOfBirth,
    String? gender,
    Value<String?> bloodGroup = const Value.absent(),
    Value<String?> phoneNumber = const Value.absent(),
    Value<String?> email = const Value.absent(),
    Value<String?> allergies = const Value.absent(),
    Value<String?> medicalConditions = const Value.absent(),
    Value<String?> medications = const Value.absent(),
    Value<String?> emergencyContact = const Value.absent(),
    bool? isActive,
    bool? hasOwnAccount,
    Value<String?> linkedAccountId = const Value.absent(),
    bool? allowIndependentAccess,
    Value<String?> caregiverPermissions = const Value.absent(),
    Value<String?> profileImageUrl = const Value.absent(),
    bool? isSynced,
    DateTime? createdAt,
    DateTime? lastModified,
  }) => FamilyMember(
    id: id ?? this.id,
    familyGroupId: familyGroupId ?? this.familyGroupId,
    primaryUserId: primaryUserId ?? this.primaryUserId,
    name: name ?? this.name,
    relationship: relationship ?? this.relationship,
    dateOfBirth: dateOfBirth ?? this.dateOfBirth,
    gender: gender ?? this.gender,
    bloodGroup: bloodGroup.present ? bloodGroup.value : this.bloodGroup,
    phoneNumber: phoneNumber.present ? phoneNumber.value : this.phoneNumber,
    email: email.present ? email.value : this.email,
    allergies: allergies.present ? allergies.value : this.allergies,
    medicalConditions: medicalConditions.present
        ? medicalConditions.value
        : this.medicalConditions,
    medications: medications.present ? medications.value : this.medications,
    emergencyContact: emergencyContact.present
        ? emergencyContact.value
        : this.emergencyContact,
    isActive: isActive ?? this.isActive,
    hasOwnAccount: hasOwnAccount ?? this.hasOwnAccount,
    linkedAccountId: linkedAccountId.present
        ? linkedAccountId.value
        : this.linkedAccountId,
    allowIndependentAccess:
        allowIndependentAccess ?? this.allowIndependentAccess,
    caregiverPermissions: caregiverPermissions.present
        ? caregiverPermissions.value
        : this.caregiverPermissions,
    profileImageUrl: profileImageUrl.present
        ? profileImageUrl.value
        : this.profileImageUrl,
    isSynced: isSynced ?? this.isSynced,
    createdAt: createdAt ?? this.createdAt,
    lastModified: lastModified ?? this.lastModified,
  );
  FamilyMember copyWithCompanion(FamilyMembersCompanion data) {
    return FamilyMember(
      id: data.id.present ? data.id.value : this.id,
      familyGroupId: data.familyGroupId.present
          ? data.familyGroupId.value
          : this.familyGroupId,
      primaryUserId: data.primaryUserId.present
          ? data.primaryUserId.value
          : this.primaryUserId,
      name: data.name.present ? data.name.value : this.name,
      relationship: data.relationship.present
          ? data.relationship.value
          : this.relationship,
      dateOfBirth: data.dateOfBirth.present
          ? data.dateOfBirth.value
          : this.dateOfBirth,
      gender: data.gender.present ? data.gender.value : this.gender,
      bloodGroup: data.bloodGroup.present
          ? data.bloodGroup.value
          : this.bloodGroup,
      phoneNumber: data.phoneNumber.present
          ? data.phoneNumber.value
          : this.phoneNumber,
      email: data.email.present ? data.email.value : this.email,
      allergies: data.allergies.present ? data.allergies.value : this.allergies,
      medicalConditions: data.medicalConditions.present
          ? data.medicalConditions.value
          : this.medicalConditions,
      medications: data.medications.present
          ? data.medications.value
          : this.medications,
      emergencyContact: data.emergencyContact.present
          ? data.emergencyContact.value
          : this.emergencyContact,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      hasOwnAccount: data.hasOwnAccount.present
          ? data.hasOwnAccount.value
          : this.hasOwnAccount,
      linkedAccountId: data.linkedAccountId.present
          ? data.linkedAccountId.value
          : this.linkedAccountId,
      allowIndependentAccess: data.allowIndependentAccess.present
          ? data.allowIndependentAccess.value
          : this.allowIndependentAccess,
      caregiverPermissions: data.caregiverPermissions.present
          ? data.caregiverPermissions.value
          : this.caregiverPermissions,
      profileImageUrl: data.profileImageUrl.present
          ? data.profileImageUrl.value
          : this.profileImageUrl,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      lastModified: data.lastModified.present
          ? data.lastModified.value
          : this.lastModified,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FamilyMember(')
          ..write('id: $id, ')
          ..write('familyGroupId: $familyGroupId, ')
          ..write('primaryUserId: $primaryUserId, ')
          ..write('name: $name, ')
          ..write('relationship: $relationship, ')
          ..write('dateOfBirth: $dateOfBirth, ')
          ..write('gender: $gender, ')
          ..write('bloodGroup: $bloodGroup, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('email: $email, ')
          ..write('allergies: $allergies, ')
          ..write('medicalConditions: $medicalConditions, ')
          ..write('medications: $medications, ')
          ..write('emergencyContact: $emergencyContact, ')
          ..write('isActive: $isActive, ')
          ..write('hasOwnAccount: $hasOwnAccount, ')
          ..write('linkedAccountId: $linkedAccountId, ')
          ..write('allowIndependentAccess: $allowIndependentAccess, ')
          ..write('caregiverPermissions: $caregiverPermissions, ')
          ..write('profileImageUrl: $profileImageUrl, ')
          ..write('isSynced: $isSynced, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastModified: $lastModified')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    familyGroupId,
    primaryUserId,
    name,
    relationship,
    dateOfBirth,
    gender,
    bloodGroup,
    phoneNumber,
    email,
    allergies,
    medicalConditions,
    medications,
    emergencyContact,
    isActive,
    hasOwnAccount,
    linkedAccountId,
    allowIndependentAccess,
    caregiverPermissions,
    profileImageUrl,
    isSynced,
    createdAt,
    lastModified,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FamilyMember &&
          other.id == this.id &&
          other.familyGroupId == this.familyGroupId &&
          other.primaryUserId == this.primaryUserId &&
          other.name == this.name &&
          other.relationship == this.relationship &&
          other.dateOfBirth == this.dateOfBirth &&
          other.gender == this.gender &&
          other.bloodGroup == this.bloodGroup &&
          other.phoneNumber == this.phoneNumber &&
          other.email == this.email &&
          other.allergies == this.allergies &&
          other.medicalConditions == this.medicalConditions &&
          other.medications == this.medications &&
          other.emergencyContact == this.emergencyContact &&
          other.isActive == this.isActive &&
          other.hasOwnAccount == this.hasOwnAccount &&
          other.linkedAccountId == this.linkedAccountId &&
          other.allowIndependentAccess == this.allowIndependentAccess &&
          other.caregiverPermissions == this.caregiverPermissions &&
          other.profileImageUrl == this.profileImageUrl &&
          other.isSynced == this.isSynced &&
          other.createdAt == this.createdAt &&
          other.lastModified == this.lastModified);
}

class FamilyMembersCompanion extends UpdateCompanion<FamilyMember> {
  final Value<String> id;
  final Value<String> familyGroupId;
  final Value<String> primaryUserId;
  final Value<String> name;
  final Value<String> relationship;
  final Value<DateTime> dateOfBirth;
  final Value<String> gender;
  final Value<String?> bloodGroup;
  final Value<String?> phoneNumber;
  final Value<String?> email;
  final Value<String?> allergies;
  final Value<String?> medicalConditions;
  final Value<String?> medications;
  final Value<String?> emergencyContact;
  final Value<bool> isActive;
  final Value<bool> hasOwnAccount;
  final Value<String?> linkedAccountId;
  final Value<bool> allowIndependentAccess;
  final Value<String?> caregiverPermissions;
  final Value<String?> profileImageUrl;
  final Value<bool> isSynced;
  final Value<DateTime> createdAt;
  final Value<DateTime> lastModified;
  final Value<int> rowid;
  const FamilyMembersCompanion({
    this.id = const Value.absent(),
    this.familyGroupId = const Value.absent(),
    this.primaryUserId = const Value.absent(),
    this.name = const Value.absent(),
    this.relationship = const Value.absent(),
    this.dateOfBirth = const Value.absent(),
    this.gender = const Value.absent(),
    this.bloodGroup = const Value.absent(),
    this.phoneNumber = const Value.absent(),
    this.email = const Value.absent(),
    this.allergies = const Value.absent(),
    this.medicalConditions = const Value.absent(),
    this.medications = const Value.absent(),
    this.emergencyContact = const Value.absent(),
    this.isActive = const Value.absent(),
    this.hasOwnAccount = const Value.absent(),
    this.linkedAccountId = const Value.absent(),
    this.allowIndependentAccess = const Value.absent(),
    this.caregiverPermissions = const Value.absent(),
    this.profileImageUrl = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastModified = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FamilyMembersCompanion.insert({
    required String id,
    required String familyGroupId,
    required String primaryUserId,
    required String name,
    required String relationship,
    required DateTime dateOfBirth,
    required String gender,
    this.bloodGroup = const Value.absent(),
    this.phoneNumber = const Value.absent(),
    this.email = const Value.absent(),
    this.allergies = const Value.absent(),
    this.medicalConditions = const Value.absent(),
    this.medications = const Value.absent(),
    this.emergencyContact = const Value.absent(),
    this.isActive = const Value.absent(),
    this.hasOwnAccount = const Value.absent(),
    this.linkedAccountId = const Value.absent(),
    this.allowIndependentAccess = const Value.absent(),
    this.caregiverPermissions = const Value.absent(),
    this.profileImageUrl = const Value.absent(),
    this.isSynced = const Value.absent(),
    required DateTime createdAt,
    required DateTime lastModified,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       familyGroupId = Value(familyGroupId),
       primaryUserId = Value(primaryUserId),
       name = Value(name),
       relationship = Value(relationship),
       dateOfBirth = Value(dateOfBirth),
       gender = Value(gender),
       createdAt = Value(createdAt),
       lastModified = Value(lastModified);
  static Insertable<FamilyMember> custom({
    Expression<String>? id,
    Expression<String>? familyGroupId,
    Expression<String>? primaryUserId,
    Expression<String>? name,
    Expression<String>? relationship,
    Expression<DateTime>? dateOfBirth,
    Expression<String>? gender,
    Expression<String>? bloodGroup,
    Expression<String>? phoneNumber,
    Expression<String>? email,
    Expression<String>? allergies,
    Expression<String>? medicalConditions,
    Expression<String>? medications,
    Expression<String>? emergencyContact,
    Expression<bool>? isActive,
    Expression<bool>? hasOwnAccount,
    Expression<String>? linkedAccountId,
    Expression<bool>? allowIndependentAccess,
    Expression<String>? caregiverPermissions,
    Expression<String>? profileImageUrl,
    Expression<bool>? isSynced,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? lastModified,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (familyGroupId != null) 'family_group_id': familyGroupId,
      if (primaryUserId != null) 'primary_user_id': primaryUserId,
      if (name != null) 'name': name,
      if (relationship != null) 'relationship': relationship,
      if (dateOfBirth != null) 'date_of_birth': dateOfBirth,
      if (gender != null) 'gender': gender,
      if (bloodGroup != null) 'blood_group': bloodGroup,
      if (phoneNumber != null) 'phone_number': phoneNumber,
      if (email != null) 'email': email,
      if (allergies != null) 'allergies': allergies,
      if (medicalConditions != null) 'medical_conditions': medicalConditions,
      if (medications != null) 'medications': medications,
      if (emergencyContact != null) 'emergency_contact': emergencyContact,
      if (isActive != null) 'is_active': isActive,
      if (hasOwnAccount != null) 'has_own_account': hasOwnAccount,
      if (linkedAccountId != null) 'linked_account_id': linkedAccountId,
      if (allowIndependentAccess != null)
        'allow_independent_access': allowIndependentAccess,
      if (caregiverPermissions != null)
        'caregiver_permissions': caregiverPermissions,
      if (profileImageUrl != null) 'profile_image_url': profileImageUrl,
      if (isSynced != null) 'is_synced': isSynced,
      if (createdAt != null) 'created_at': createdAt,
      if (lastModified != null) 'last_modified': lastModified,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FamilyMembersCompanion copyWith({
    Value<String>? id,
    Value<String>? familyGroupId,
    Value<String>? primaryUserId,
    Value<String>? name,
    Value<String>? relationship,
    Value<DateTime>? dateOfBirth,
    Value<String>? gender,
    Value<String?>? bloodGroup,
    Value<String?>? phoneNumber,
    Value<String?>? email,
    Value<String?>? allergies,
    Value<String?>? medicalConditions,
    Value<String?>? medications,
    Value<String?>? emergencyContact,
    Value<bool>? isActive,
    Value<bool>? hasOwnAccount,
    Value<String?>? linkedAccountId,
    Value<bool>? allowIndependentAccess,
    Value<String?>? caregiverPermissions,
    Value<String?>? profileImageUrl,
    Value<bool>? isSynced,
    Value<DateTime>? createdAt,
    Value<DateTime>? lastModified,
    Value<int>? rowid,
  }) {
    return FamilyMembersCompanion(
      id: id ?? this.id,
      familyGroupId: familyGroupId ?? this.familyGroupId,
      primaryUserId: primaryUserId ?? this.primaryUserId,
      name: name ?? this.name,
      relationship: relationship ?? this.relationship,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      allergies: allergies ?? this.allergies,
      medicalConditions: medicalConditions ?? this.medicalConditions,
      medications: medications ?? this.medications,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      isActive: isActive ?? this.isActive,
      hasOwnAccount: hasOwnAccount ?? this.hasOwnAccount,
      linkedAccountId: linkedAccountId ?? this.linkedAccountId,
      allowIndependentAccess:
          allowIndependentAccess ?? this.allowIndependentAccess,
      caregiverPermissions: caregiverPermissions ?? this.caregiverPermissions,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      isSynced: isSynced ?? this.isSynced,
      createdAt: createdAt ?? this.createdAt,
      lastModified: lastModified ?? this.lastModified,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (familyGroupId.present) {
      map['family_group_id'] = Variable<String>(familyGroupId.value);
    }
    if (primaryUserId.present) {
      map['primary_user_id'] = Variable<String>(primaryUserId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (relationship.present) {
      map['relationship'] = Variable<String>(relationship.value);
    }
    if (dateOfBirth.present) {
      map['date_of_birth'] = Variable<DateTime>(dateOfBirth.value);
    }
    if (gender.present) {
      map['gender'] = Variable<String>(gender.value);
    }
    if (bloodGroup.present) {
      map['blood_group'] = Variable<String>(bloodGroup.value);
    }
    if (phoneNumber.present) {
      map['phone_number'] = Variable<String>(phoneNumber.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (allergies.present) {
      map['allergies'] = Variable<String>(allergies.value);
    }
    if (medicalConditions.present) {
      map['medical_conditions'] = Variable<String>(medicalConditions.value);
    }
    if (medications.present) {
      map['medications'] = Variable<String>(medications.value);
    }
    if (emergencyContact.present) {
      map['emergency_contact'] = Variable<String>(emergencyContact.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (hasOwnAccount.present) {
      map['has_own_account'] = Variable<bool>(hasOwnAccount.value);
    }
    if (linkedAccountId.present) {
      map['linked_account_id'] = Variable<String>(linkedAccountId.value);
    }
    if (allowIndependentAccess.present) {
      map['allow_independent_access'] = Variable<bool>(
        allowIndependentAccess.value,
      );
    }
    if (caregiverPermissions.present) {
      map['caregiver_permissions'] = Variable<String>(
        caregiverPermissions.value,
      );
    }
    if (profileImageUrl.present) {
      map['profile_image_url'] = Variable<String>(profileImageUrl.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (lastModified.present) {
      map['last_modified'] = Variable<DateTime>(lastModified.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FamilyMembersCompanion(')
          ..write('id: $id, ')
          ..write('familyGroupId: $familyGroupId, ')
          ..write('primaryUserId: $primaryUserId, ')
          ..write('name: $name, ')
          ..write('relationship: $relationship, ')
          ..write('dateOfBirth: $dateOfBirth, ')
          ..write('gender: $gender, ')
          ..write('bloodGroup: $bloodGroup, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('email: $email, ')
          ..write('allergies: $allergies, ')
          ..write('medicalConditions: $medicalConditions, ')
          ..write('medications: $medications, ')
          ..write('emergencyContact: $emergencyContact, ')
          ..write('isActive: $isActive, ')
          ..write('hasOwnAccount: $hasOwnAccount, ')
          ..write('linkedAccountId: $linkedAccountId, ')
          ..write('allowIndependentAccess: $allowIndependentAccess, ')
          ..write('caregiverPermissions: $caregiverPermissions, ')
          ..write('profileImageUrl: $profileImageUrl, ')
          ..write('isSynced: $isSynced, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastModified: $lastModified, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FamilyGroupsTable extends FamilyGroups
    with TableInfo<$FamilyGroupsTable, FamilyGroup> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FamilyGroupsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _primaryMemberIdMeta = const VerificationMeta(
    'primaryMemberId',
  );
  @override
  late final GeneratedColumn<String> primaryMemberId = GeneratedColumn<String>(
    'primary_member_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _familyNameMeta = const VerificationMeta(
    'familyName',
  );
  @override
  late final GeneratedColumn<String> familyName = GeneratedColumn<String>(
    'family_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _villageMeta = const VerificationMeta(
    'village',
  );
  @override
  late final GeneratedColumn<String> village = GeneratedColumn<String>(
    'village',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pincodeMeta = const VerificationMeta(
    'pincode',
  );
  @override
  late final GeneratedColumn<String> pincode = GeneratedColumn<String>(
    'pincode',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _emergencyContactMeta = const VerificationMeta(
    'emergencyContact',
  );
  @override
  late final GeneratedColumn<String> emergencyContact = GeneratedColumn<String>(
    'emergency_contact',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _emergencyPhoneMeta = const VerificationMeta(
    'emergencyPhone',
  );
  @override
  late final GeneratedColumn<String> emergencyPhone = GeneratedColumn<String>(
    'emergency_phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _healthInsuranceMeta = const VerificationMeta(
    'healthInsurance',
  );
  @override
  late final GeneratedColumn<String> healthInsurance = GeneratedColumn<String>(
    'health_insurance',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastModifiedMeta = const VerificationMeta(
    'lastModified',
  );
  @override
  late final GeneratedColumn<DateTime> lastModified = GeneratedColumn<DateTime>(
    'last_modified',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    primaryMemberId,
    familyName,
    address,
    village,
    pincode,
    emergencyContact,
    emergencyPhone,
    healthInsurance,
    isActive,
    isSynced,
    createdAt,
    lastModified,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'family_groups';
  @override
  VerificationContext validateIntegrity(
    Insertable<FamilyGroup> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('primary_member_id')) {
      context.handle(
        _primaryMemberIdMeta,
        primaryMemberId.isAcceptableOrUnknown(
          data['primary_member_id']!,
          _primaryMemberIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_primaryMemberIdMeta);
    }
    if (data.containsKey('family_name')) {
      context.handle(
        _familyNameMeta,
        familyName.isAcceptableOrUnknown(data['family_name']!, _familyNameMeta),
      );
    } else if (isInserting) {
      context.missing(_familyNameMeta);
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    }
    if (data.containsKey('village')) {
      context.handle(
        _villageMeta,
        village.isAcceptableOrUnknown(data['village']!, _villageMeta),
      );
    }
    if (data.containsKey('pincode')) {
      context.handle(
        _pincodeMeta,
        pincode.isAcceptableOrUnknown(data['pincode']!, _pincodeMeta),
      );
    }
    if (data.containsKey('emergency_contact')) {
      context.handle(
        _emergencyContactMeta,
        emergencyContact.isAcceptableOrUnknown(
          data['emergency_contact']!,
          _emergencyContactMeta,
        ),
      );
    }
    if (data.containsKey('emergency_phone')) {
      context.handle(
        _emergencyPhoneMeta,
        emergencyPhone.isAcceptableOrUnknown(
          data['emergency_phone']!,
          _emergencyPhoneMeta,
        ),
      );
    }
    if (data.containsKey('health_insurance')) {
      context.handle(
        _healthInsuranceMeta,
        healthInsurance.isAcceptableOrUnknown(
          data['health_insurance']!,
          _healthInsuranceMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('last_modified')) {
      context.handle(
        _lastModifiedMeta,
        lastModified.isAcceptableOrUnknown(
          data['last_modified']!,
          _lastModifiedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastModifiedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FamilyGroup map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FamilyGroup(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      primaryMemberId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}primary_member_id'],
      )!,
      familyName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}family_name'],
      )!,
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      ),
      village: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}village'],
      ),
      pincode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pincode'],
      ),
      emergencyContact: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}emergency_contact'],
      ),
      emergencyPhone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}emergency_phone'],
      ),
      healthInsurance: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}health_insurance'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      lastModified: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_modified'],
      )!,
    );
  }

  @override
  $FamilyGroupsTable createAlias(String alias) {
    return $FamilyGroupsTable(attachedDatabase, alias);
  }
}

class FamilyGroup extends DataClass implements Insertable<FamilyGroup> {
  final String id;
  final String primaryMemberId;
  final String familyName;
  final String? address;
  final String? village;
  final String? pincode;
  final String? emergencyContact;
  final String? emergencyPhone;
  final String? healthInsurance;
  final bool isActive;
  final bool isSynced;
  final DateTime createdAt;
  final DateTime lastModified;
  const FamilyGroup({
    required this.id,
    required this.primaryMemberId,
    required this.familyName,
    this.address,
    this.village,
    this.pincode,
    this.emergencyContact,
    this.emergencyPhone,
    this.healthInsurance,
    required this.isActive,
    required this.isSynced,
    required this.createdAt,
    required this.lastModified,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['primary_member_id'] = Variable<String>(primaryMemberId);
    map['family_name'] = Variable<String>(familyName);
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    if (!nullToAbsent || village != null) {
      map['village'] = Variable<String>(village);
    }
    if (!nullToAbsent || pincode != null) {
      map['pincode'] = Variable<String>(pincode);
    }
    if (!nullToAbsent || emergencyContact != null) {
      map['emergency_contact'] = Variable<String>(emergencyContact);
    }
    if (!nullToAbsent || emergencyPhone != null) {
      map['emergency_phone'] = Variable<String>(emergencyPhone);
    }
    if (!nullToAbsent || healthInsurance != null) {
      map['health_insurance'] = Variable<String>(healthInsurance);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['is_synced'] = Variable<bool>(isSynced);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['last_modified'] = Variable<DateTime>(lastModified);
    return map;
  }

  FamilyGroupsCompanion toCompanion(bool nullToAbsent) {
    return FamilyGroupsCompanion(
      id: Value(id),
      primaryMemberId: Value(primaryMemberId),
      familyName: Value(familyName),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      village: village == null && nullToAbsent
          ? const Value.absent()
          : Value(village),
      pincode: pincode == null && nullToAbsent
          ? const Value.absent()
          : Value(pincode),
      emergencyContact: emergencyContact == null && nullToAbsent
          ? const Value.absent()
          : Value(emergencyContact),
      emergencyPhone: emergencyPhone == null && nullToAbsent
          ? const Value.absent()
          : Value(emergencyPhone),
      healthInsurance: healthInsurance == null && nullToAbsent
          ? const Value.absent()
          : Value(healthInsurance),
      isActive: Value(isActive),
      isSynced: Value(isSynced),
      createdAt: Value(createdAt),
      lastModified: Value(lastModified),
    );
  }

  factory FamilyGroup.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FamilyGroup(
      id: serializer.fromJson<String>(json['id']),
      primaryMemberId: serializer.fromJson<String>(json['primaryMemberId']),
      familyName: serializer.fromJson<String>(json['familyName']),
      address: serializer.fromJson<String?>(json['address']),
      village: serializer.fromJson<String?>(json['village']),
      pincode: serializer.fromJson<String?>(json['pincode']),
      emergencyContact: serializer.fromJson<String?>(json['emergencyContact']),
      emergencyPhone: serializer.fromJson<String?>(json['emergencyPhone']),
      healthInsurance: serializer.fromJson<String?>(json['healthInsurance']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      lastModified: serializer.fromJson<DateTime>(json['lastModified']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'primaryMemberId': serializer.toJson<String>(primaryMemberId),
      'familyName': serializer.toJson<String>(familyName),
      'address': serializer.toJson<String?>(address),
      'village': serializer.toJson<String?>(village),
      'pincode': serializer.toJson<String?>(pincode),
      'emergencyContact': serializer.toJson<String?>(emergencyContact),
      'emergencyPhone': serializer.toJson<String?>(emergencyPhone),
      'healthInsurance': serializer.toJson<String?>(healthInsurance),
      'isActive': serializer.toJson<bool>(isActive),
      'isSynced': serializer.toJson<bool>(isSynced),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'lastModified': serializer.toJson<DateTime>(lastModified),
    };
  }

  FamilyGroup copyWith({
    String? id,
    String? primaryMemberId,
    String? familyName,
    Value<String?> address = const Value.absent(),
    Value<String?> village = const Value.absent(),
    Value<String?> pincode = const Value.absent(),
    Value<String?> emergencyContact = const Value.absent(),
    Value<String?> emergencyPhone = const Value.absent(),
    Value<String?> healthInsurance = const Value.absent(),
    bool? isActive,
    bool? isSynced,
    DateTime? createdAt,
    DateTime? lastModified,
  }) => FamilyGroup(
    id: id ?? this.id,
    primaryMemberId: primaryMemberId ?? this.primaryMemberId,
    familyName: familyName ?? this.familyName,
    address: address.present ? address.value : this.address,
    village: village.present ? village.value : this.village,
    pincode: pincode.present ? pincode.value : this.pincode,
    emergencyContact: emergencyContact.present
        ? emergencyContact.value
        : this.emergencyContact,
    emergencyPhone: emergencyPhone.present
        ? emergencyPhone.value
        : this.emergencyPhone,
    healthInsurance: healthInsurance.present
        ? healthInsurance.value
        : this.healthInsurance,
    isActive: isActive ?? this.isActive,
    isSynced: isSynced ?? this.isSynced,
    createdAt: createdAt ?? this.createdAt,
    lastModified: lastModified ?? this.lastModified,
  );
  FamilyGroup copyWithCompanion(FamilyGroupsCompanion data) {
    return FamilyGroup(
      id: data.id.present ? data.id.value : this.id,
      primaryMemberId: data.primaryMemberId.present
          ? data.primaryMemberId.value
          : this.primaryMemberId,
      familyName: data.familyName.present
          ? data.familyName.value
          : this.familyName,
      address: data.address.present ? data.address.value : this.address,
      village: data.village.present ? data.village.value : this.village,
      pincode: data.pincode.present ? data.pincode.value : this.pincode,
      emergencyContact: data.emergencyContact.present
          ? data.emergencyContact.value
          : this.emergencyContact,
      emergencyPhone: data.emergencyPhone.present
          ? data.emergencyPhone.value
          : this.emergencyPhone,
      healthInsurance: data.healthInsurance.present
          ? data.healthInsurance.value
          : this.healthInsurance,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      lastModified: data.lastModified.present
          ? data.lastModified.value
          : this.lastModified,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FamilyGroup(')
          ..write('id: $id, ')
          ..write('primaryMemberId: $primaryMemberId, ')
          ..write('familyName: $familyName, ')
          ..write('address: $address, ')
          ..write('village: $village, ')
          ..write('pincode: $pincode, ')
          ..write('emergencyContact: $emergencyContact, ')
          ..write('emergencyPhone: $emergencyPhone, ')
          ..write('healthInsurance: $healthInsurance, ')
          ..write('isActive: $isActive, ')
          ..write('isSynced: $isSynced, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastModified: $lastModified')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    primaryMemberId,
    familyName,
    address,
    village,
    pincode,
    emergencyContact,
    emergencyPhone,
    healthInsurance,
    isActive,
    isSynced,
    createdAt,
    lastModified,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FamilyGroup &&
          other.id == this.id &&
          other.primaryMemberId == this.primaryMemberId &&
          other.familyName == this.familyName &&
          other.address == this.address &&
          other.village == this.village &&
          other.pincode == this.pincode &&
          other.emergencyContact == this.emergencyContact &&
          other.emergencyPhone == this.emergencyPhone &&
          other.healthInsurance == this.healthInsurance &&
          other.isActive == this.isActive &&
          other.isSynced == this.isSynced &&
          other.createdAt == this.createdAt &&
          other.lastModified == this.lastModified);
}

class FamilyGroupsCompanion extends UpdateCompanion<FamilyGroup> {
  final Value<String> id;
  final Value<String> primaryMemberId;
  final Value<String> familyName;
  final Value<String?> address;
  final Value<String?> village;
  final Value<String?> pincode;
  final Value<String?> emergencyContact;
  final Value<String?> emergencyPhone;
  final Value<String?> healthInsurance;
  final Value<bool> isActive;
  final Value<bool> isSynced;
  final Value<DateTime> createdAt;
  final Value<DateTime> lastModified;
  final Value<int> rowid;
  const FamilyGroupsCompanion({
    this.id = const Value.absent(),
    this.primaryMemberId = const Value.absent(),
    this.familyName = const Value.absent(),
    this.address = const Value.absent(),
    this.village = const Value.absent(),
    this.pincode = const Value.absent(),
    this.emergencyContact = const Value.absent(),
    this.emergencyPhone = const Value.absent(),
    this.healthInsurance = const Value.absent(),
    this.isActive = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastModified = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FamilyGroupsCompanion.insert({
    required String id,
    required String primaryMemberId,
    required String familyName,
    this.address = const Value.absent(),
    this.village = const Value.absent(),
    this.pincode = const Value.absent(),
    this.emergencyContact = const Value.absent(),
    this.emergencyPhone = const Value.absent(),
    this.healthInsurance = const Value.absent(),
    this.isActive = const Value.absent(),
    this.isSynced = const Value.absent(),
    required DateTime createdAt,
    required DateTime lastModified,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       primaryMemberId = Value(primaryMemberId),
       familyName = Value(familyName),
       createdAt = Value(createdAt),
       lastModified = Value(lastModified);
  static Insertable<FamilyGroup> custom({
    Expression<String>? id,
    Expression<String>? primaryMemberId,
    Expression<String>? familyName,
    Expression<String>? address,
    Expression<String>? village,
    Expression<String>? pincode,
    Expression<String>? emergencyContact,
    Expression<String>? emergencyPhone,
    Expression<String>? healthInsurance,
    Expression<bool>? isActive,
    Expression<bool>? isSynced,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? lastModified,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (primaryMemberId != null) 'primary_member_id': primaryMemberId,
      if (familyName != null) 'family_name': familyName,
      if (address != null) 'address': address,
      if (village != null) 'village': village,
      if (pincode != null) 'pincode': pincode,
      if (emergencyContact != null) 'emergency_contact': emergencyContact,
      if (emergencyPhone != null) 'emergency_phone': emergencyPhone,
      if (healthInsurance != null) 'health_insurance': healthInsurance,
      if (isActive != null) 'is_active': isActive,
      if (isSynced != null) 'is_synced': isSynced,
      if (createdAt != null) 'created_at': createdAt,
      if (lastModified != null) 'last_modified': lastModified,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FamilyGroupsCompanion copyWith({
    Value<String>? id,
    Value<String>? primaryMemberId,
    Value<String>? familyName,
    Value<String?>? address,
    Value<String?>? village,
    Value<String?>? pincode,
    Value<String?>? emergencyContact,
    Value<String?>? emergencyPhone,
    Value<String?>? healthInsurance,
    Value<bool>? isActive,
    Value<bool>? isSynced,
    Value<DateTime>? createdAt,
    Value<DateTime>? lastModified,
    Value<int>? rowid,
  }) {
    return FamilyGroupsCompanion(
      id: id ?? this.id,
      primaryMemberId: primaryMemberId ?? this.primaryMemberId,
      familyName: familyName ?? this.familyName,
      address: address ?? this.address,
      village: village ?? this.village,
      pincode: pincode ?? this.pincode,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      emergencyPhone: emergencyPhone ?? this.emergencyPhone,
      healthInsurance: healthInsurance ?? this.healthInsurance,
      isActive: isActive ?? this.isActive,
      isSynced: isSynced ?? this.isSynced,
      createdAt: createdAt ?? this.createdAt,
      lastModified: lastModified ?? this.lastModified,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (primaryMemberId.present) {
      map['primary_member_id'] = Variable<String>(primaryMemberId.value);
    }
    if (familyName.present) {
      map['family_name'] = Variable<String>(familyName.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (village.present) {
      map['village'] = Variable<String>(village.value);
    }
    if (pincode.present) {
      map['pincode'] = Variable<String>(pincode.value);
    }
    if (emergencyContact.present) {
      map['emergency_contact'] = Variable<String>(emergencyContact.value);
    }
    if (emergencyPhone.present) {
      map['emergency_phone'] = Variable<String>(emergencyPhone.value);
    }
    if (healthInsurance.present) {
      map['health_insurance'] = Variable<String>(healthInsurance.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (lastModified.present) {
      map['last_modified'] = Variable<DateTime>(lastModified.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FamilyGroupsCompanion(')
          ..write('id: $id, ')
          ..write('primaryMemberId: $primaryMemberId, ')
          ..write('familyName: $familyName, ')
          ..write('address: $address, ')
          ..write('village: $village, ')
          ..write('pincode: $pincode, ')
          ..write('emergencyContact: $emergencyContact, ')
          ..write('emergencyPhone: $emergencyPhone, ')
          ..write('healthInsurance: $healthInsurance, ')
          ..write('isActive: $isActive, ')
          ..write('isSynced: $isSynced, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastModified: $lastModified, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FamilyHealthRecordsTable extends FamilyHealthRecords
    with TableInfo<$FamilyHealthRecordsTable, FamilyHealthRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FamilyHealthRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _familyMemberIdMeta = const VerificationMeta(
    'familyMemberId',
  );
  @override
  late final GeneratedColumn<String> familyMemberId = GeneratedColumn<String>(
    'family_member_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _familyGroupIdMeta = const VerificationMeta(
    'familyGroupId',
  );
  @override
  late final GeneratedColumn<String> familyGroupId = GeneratedColumn<String>(
    'family_group_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recordTypeMeta = const VerificationMeta(
    'recordType',
  );
  @override
  late final GeneratedColumn<String> recordType = GeneratedColumn<String>(
    'record_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _conditionMeta = const VerificationMeta(
    'condition',
  );
  @override
  late final GeneratedColumn<String> condition = GeneratedColumn<String>(
    'condition',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _symptomsMeta = const VerificationMeta(
    'symptoms',
  );
  @override
  late final GeneratedColumn<String> symptoms = GeneratedColumn<String>(
    'symptoms',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _severityMeta = const VerificationMeta(
    'severity',
  );
  @override
  late final GeneratedColumn<String> severity = GeneratedColumn<String>(
    'severity',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('normal'),
  );
  static const VerificationMeta _treatmentMeta = const VerificationMeta(
    'treatment',
  );
  @override
  late final GeneratedColumn<String> treatment = GeneratedColumn<String>(
    'treatment',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _medicationsMeta = const VerificationMeta(
    'medications',
  );
  @override
  late final GeneratedColumn<String> medications = GeneratedColumn<String>(
    'medications',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _doctorNameMeta = const VerificationMeta(
    'doctorName',
  );
  @override
  late final GeneratedColumn<String> doctorName = GeneratedColumn<String>(
    'doctor_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hospitalNameMeta = const VerificationMeta(
    'hospitalName',
  );
  @override
  late final GeneratedColumn<String> hospitalName = GeneratedColumn<String>(
    'hospital_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _reportUrlMeta = const VerificationMeta(
    'reportUrl',
  );
  @override
  late final GeneratedColumn<String> reportUrl = GeneratedColumn<String>(
    'report_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _attachmentsMeta = const VerificationMeta(
    'attachments',
  );
  @override
  late final GeneratedColumn<String> attachments = GeneratedColumn<String>(
    'attachments',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _recordDateMeta = const VerificationMeta(
    'recordDate',
  );
  @override
  late final GeneratedColumn<DateTime> recordDate = GeneratedColumn<DateTime>(
    'record_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _followUpDateMeta = const VerificationMeta(
    'followUpDate',
  );
  @override
  late final GeneratedColumn<DateTime> followUpDate = GeneratedColumn<DateTime>(
    'follow_up_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isEmergencyMeta = const VerificationMeta(
    'isEmergency',
  );
  @override
  late final GeneratedColumn<bool> isEmergency = GeneratedColumn<bool>(
    'is_emergency',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_emergency" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isResolvedMeta = const VerificationMeta(
    'isResolved',
  );
  @override
  late final GeneratedColumn<bool> isResolved = GeneratedColumn<bool>(
    'is_resolved',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_resolved" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastModifiedMeta = const VerificationMeta(
    'lastModified',
  );
  @override
  late final GeneratedColumn<DateTime> lastModified = GeneratedColumn<DateTime>(
    'last_modified',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    familyMemberId,
    familyGroupId,
    recordType,
    title,
    description,
    condition,
    symptoms,
    severity,
    treatment,
    medications,
    doctorName,
    hospitalName,
    reportUrl,
    attachments,
    recordDate,
    followUpDate,
    isEmergency,
    isResolved,
    notes,
    isSynced,
    createdAt,
    lastModified,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'family_health_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<FamilyHealthRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('family_member_id')) {
      context.handle(
        _familyMemberIdMeta,
        familyMemberId.isAcceptableOrUnknown(
          data['family_member_id']!,
          _familyMemberIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_familyMemberIdMeta);
    }
    if (data.containsKey('family_group_id')) {
      context.handle(
        _familyGroupIdMeta,
        familyGroupId.isAcceptableOrUnknown(
          data['family_group_id']!,
          _familyGroupIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_familyGroupIdMeta);
    }
    if (data.containsKey('record_type')) {
      context.handle(
        _recordTypeMeta,
        recordType.isAcceptableOrUnknown(data['record_type']!, _recordTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_recordTypeMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('condition')) {
      context.handle(
        _conditionMeta,
        condition.isAcceptableOrUnknown(data['condition']!, _conditionMeta),
      );
    }
    if (data.containsKey('symptoms')) {
      context.handle(
        _symptomsMeta,
        symptoms.isAcceptableOrUnknown(data['symptoms']!, _symptomsMeta),
      );
    }
    if (data.containsKey('severity')) {
      context.handle(
        _severityMeta,
        severity.isAcceptableOrUnknown(data['severity']!, _severityMeta),
      );
    }
    if (data.containsKey('treatment')) {
      context.handle(
        _treatmentMeta,
        treatment.isAcceptableOrUnknown(data['treatment']!, _treatmentMeta),
      );
    }
    if (data.containsKey('medications')) {
      context.handle(
        _medicationsMeta,
        medications.isAcceptableOrUnknown(
          data['medications']!,
          _medicationsMeta,
        ),
      );
    }
    if (data.containsKey('doctor_name')) {
      context.handle(
        _doctorNameMeta,
        doctorName.isAcceptableOrUnknown(data['doctor_name']!, _doctorNameMeta),
      );
    }
    if (data.containsKey('hospital_name')) {
      context.handle(
        _hospitalNameMeta,
        hospitalName.isAcceptableOrUnknown(
          data['hospital_name']!,
          _hospitalNameMeta,
        ),
      );
    }
    if (data.containsKey('report_url')) {
      context.handle(
        _reportUrlMeta,
        reportUrl.isAcceptableOrUnknown(data['report_url']!, _reportUrlMeta),
      );
    }
    if (data.containsKey('attachments')) {
      context.handle(
        _attachmentsMeta,
        attachments.isAcceptableOrUnknown(
          data['attachments']!,
          _attachmentsMeta,
        ),
      );
    }
    if (data.containsKey('record_date')) {
      context.handle(
        _recordDateMeta,
        recordDate.isAcceptableOrUnknown(data['record_date']!, _recordDateMeta),
      );
    } else if (isInserting) {
      context.missing(_recordDateMeta);
    }
    if (data.containsKey('follow_up_date')) {
      context.handle(
        _followUpDateMeta,
        followUpDate.isAcceptableOrUnknown(
          data['follow_up_date']!,
          _followUpDateMeta,
        ),
      );
    }
    if (data.containsKey('is_emergency')) {
      context.handle(
        _isEmergencyMeta,
        isEmergency.isAcceptableOrUnknown(
          data['is_emergency']!,
          _isEmergencyMeta,
        ),
      );
    }
    if (data.containsKey('is_resolved')) {
      context.handle(
        _isResolvedMeta,
        isResolved.isAcceptableOrUnknown(data['is_resolved']!, _isResolvedMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('last_modified')) {
      context.handle(
        _lastModifiedMeta,
        lastModified.isAcceptableOrUnknown(
          data['last_modified']!,
          _lastModifiedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastModifiedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FamilyHealthRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FamilyHealthRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      familyMemberId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}family_member_id'],
      )!,
      familyGroupId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}family_group_id'],
      )!,
      recordType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}record_type'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      condition: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}condition'],
      ),
      symptoms: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}symptoms'],
      ),
      severity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}severity'],
      )!,
      treatment: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}treatment'],
      ),
      medications: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}medications'],
      ),
      doctorName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}doctor_name'],
      ),
      hospitalName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hospital_name'],
      ),
      reportUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}report_url'],
      ),
      attachments: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}attachments'],
      ),
      recordDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}record_date'],
      )!,
      followUpDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}follow_up_date'],
      ),
      isEmergency: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_emergency'],
      )!,
      isResolved: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_resolved'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      lastModified: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_modified'],
      )!,
    );
  }

  @override
  $FamilyHealthRecordsTable createAlias(String alias) {
    return $FamilyHealthRecordsTable(attachedDatabase, alias);
  }
}

class FamilyHealthRecord extends DataClass
    implements Insertable<FamilyHealthRecord> {
  final String id;
  final String familyMemberId;
  final String familyGroupId;
  final String recordType;
  final String title;
  final String? description;
  final String? condition;
  final String? symptoms;
  final String severity;
  final String? treatment;
  final String? medications;
  final String? doctorName;
  final String? hospitalName;
  final String? reportUrl;
  final String? attachments;
  final DateTime recordDate;
  final DateTime? followUpDate;
  final bool isEmergency;
  final bool isResolved;
  final String? notes;
  final bool isSynced;
  final DateTime createdAt;
  final DateTime lastModified;
  const FamilyHealthRecord({
    required this.id,
    required this.familyMemberId,
    required this.familyGroupId,
    required this.recordType,
    required this.title,
    this.description,
    this.condition,
    this.symptoms,
    required this.severity,
    this.treatment,
    this.medications,
    this.doctorName,
    this.hospitalName,
    this.reportUrl,
    this.attachments,
    required this.recordDate,
    this.followUpDate,
    required this.isEmergency,
    required this.isResolved,
    this.notes,
    required this.isSynced,
    required this.createdAt,
    required this.lastModified,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['family_member_id'] = Variable<String>(familyMemberId);
    map['family_group_id'] = Variable<String>(familyGroupId);
    map['record_type'] = Variable<String>(recordType);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || condition != null) {
      map['condition'] = Variable<String>(condition);
    }
    if (!nullToAbsent || symptoms != null) {
      map['symptoms'] = Variable<String>(symptoms);
    }
    map['severity'] = Variable<String>(severity);
    if (!nullToAbsent || treatment != null) {
      map['treatment'] = Variable<String>(treatment);
    }
    if (!nullToAbsent || medications != null) {
      map['medications'] = Variable<String>(medications);
    }
    if (!nullToAbsent || doctorName != null) {
      map['doctor_name'] = Variable<String>(doctorName);
    }
    if (!nullToAbsent || hospitalName != null) {
      map['hospital_name'] = Variable<String>(hospitalName);
    }
    if (!nullToAbsent || reportUrl != null) {
      map['report_url'] = Variable<String>(reportUrl);
    }
    if (!nullToAbsent || attachments != null) {
      map['attachments'] = Variable<String>(attachments);
    }
    map['record_date'] = Variable<DateTime>(recordDate);
    if (!nullToAbsent || followUpDate != null) {
      map['follow_up_date'] = Variable<DateTime>(followUpDate);
    }
    map['is_emergency'] = Variable<bool>(isEmergency);
    map['is_resolved'] = Variable<bool>(isResolved);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['is_synced'] = Variable<bool>(isSynced);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['last_modified'] = Variable<DateTime>(lastModified);
    return map;
  }

  FamilyHealthRecordsCompanion toCompanion(bool nullToAbsent) {
    return FamilyHealthRecordsCompanion(
      id: Value(id),
      familyMemberId: Value(familyMemberId),
      familyGroupId: Value(familyGroupId),
      recordType: Value(recordType),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      condition: condition == null && nullToAbsent
          ? const Value.absent()
          : Value(condition),
      symptoms: symptoms == null && nullToAbsent
          ? const Value.absent()
          : Value(symptoms),
      severity: Value(severity),
      treatment: treatment == null && nullToAbsent
          ? const Value.absent()
          : Value(treatment),
      medications: medications == null && nullToAbsent
          ? const Value.absent()
          : Value(medications),
      doctorName: doctorName == null && nullToAbsent
          ? const Value.absent()
          : Value(doctorName),
      hospitalName: hospitalName == null && nullToAbsent
          ? const Value.absent()
          : Value(hospitalName),
      reportUrl: reportUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(reportUrl),
      attachments: attachments == null && nullToAbsent
          ? const Value.absent()
          : Value(attachments),
      recordDate: Value(recordDate),
      followUpDate: followUpDate == null && nullToAbsent
          ? const Value.absent()
          : Value(followUpDate),
      isEmergency: Value(isEmergency),
      isResolved: Value(isResolved),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      isSynced: Value(isSynced),
      createdAt: Value(createdAt),
      lastModified: Value(lastModified),
    );
  }

  factory FamilyHealthRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FamilyHealthRecord(
      id: serializer.fromJson<String>(json['id']),
      familyMemberId: serializer.fromJson<String>(json['familyMemberId']),
      familyGroupId: serializer.fromJson<String>(json['familyGroupId']),
      recordType: serializer.fromJson<String>(json['recordType']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      condition: serializer.fromJson<String?>(json['condition']),
      symptoms: serializer.fromJson<String?>(json['symptoms']),
      severity: serializer.fromJson<String>(json['severity']),
      treatment: serializer.fromJson<String?>(json['treatment']),
      medications: serializer.fromJson<String?>(json['medications']),
      doctorName: serializer.fromJson<String?>(json['doctorName']),
      hospitalName: serializer.fromJson<String?>(json['hospitalName']),
      reportUrl: serializer.fromJson<String?>(json['reportUrl']),
      attachments: serializer.fromJson<String?>(json['attachments']),
      recordDate: serializer.fromJson<DateTime>(json['recordDate']),
      followUpDate: serializer.fromJson<DateTime?>(json['followUpDate']),
      isEmergency: serializer.fromJson<bool>(json['isEmergency']),
      isResolved: serializer.fromJson<bool>(json['isResolved']),
      notes: serializer.fromJson<String?>(json['notes']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      lastModified: serializer.fromJson<DateTime>(json['lastModified']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'familyMemberId': serializer.toJson<String>(familyMemberId),
      'familyGroupId': serializer.toJson<String>(familyGroupId),
      'recordType': serializer.toJson<String>(recordType),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'condition': serializer.toJson<String?>(condition),
      'symptoms': serializer.toJson<String?>(symptoms),
      'severity': serializer.toJson<String>(severity),
      'treatment': serializer.toJson<String?>(treatment),
      'medications': serializer.toJson<String?>(medications),
      'doctorName': serializer.toJson<String?>(doctorName),
      'hospitalName': serializer.toJson<String?>(hospitalName),
      'reportUrl': serializer.toJson<String?>(reportUrl),
      'attachments': serializer.toJson<String?>(attachments),
      'recordDate': serializer.toJson<DateTime>(recordDate),
      'followUpDate': serializer.toJson<DateTime?>(followUpDate),
      'isEmergency': serializer.toJson<bool>(isEmergency),
      'isResolved': serializer.toJson<bool>(isResolved),
      'notes': serializer.toJson<String?>(notes),
      'isSynced': serializer.toJson<bool>(isSynced),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'lastModified': serializer.toJson<DateTime>(lastModified),
    };
  }

  FamilyHealthRecord copyWith({
    String? id,
    String? familyMemberId,
    String? familyGroupId,
    String? recordType,
    String? title,
    Value<String?> description = const Value.absent(),
    Value<String?> condition = const Value.absent(),
    Value<String?> symptoms = const Value.absent(),
    String? severity,
    Value<String?> treatment = const Value.absent(),
    Value<String?> medications = const Value.absent(),
    Value<String?> doctorName = const Value.absent(),
    Value<String?> hospitalName = const Value.absent(),
    Value<String?> reportUrl = const Value.absent(),
    Value<String?> attachments = const Value.absent(),
    DateTime? recordDate,
    Value<DateTime?> followUpDate = const Value.absent(),
    bool? isEmergency,
    bool? isResolved,
    Value<String?> notes = const Value.absent(),
    bool? isSynced,
    DateTime? createdAt,
    DateTime? lastModified,
  }) => FamilyHealthRecord(
    id: id ?? this.id,
    familyMemberId: familyMemberId ?? this.familyMemberId,
    familyGroupId: familyGroupId ?? this.familyGroupId,
    recordType: recordType ?? this.recordType,
    title: title ?? this.title,
    description: description.present ? description.value : this.description,
    condition: condition.present ? condition.value : this.condition,
    symptoms: symptoms.present ? symptoms.value : this.symptoms,
    severity: severity ?? this.severity,
    treatment: treatment.present ? treatment.value : this.treatment,
    medications: medications.present ? medications.value : this.medications,
    doctorName: doctorName.present ? doctorName.value : this.doctorName,
    hospitalName: hospitalName.present ? hospitalName.value : this.hospitalName,
    reportUrl: reportUrl.present ? reportUrl.value : this.reportUrl,
    attachments: attachments.present ? attachments.value : this.attachments,
    recordDate: recordDate ?? this.recordDate,
    followUpDate: followUpDate.present ? followUpDate.value : this.followUpDate,
    isEmergency: isEmergency ?? this.isEmergency,
    isResolved: isResolved ?? this.isResolved,
    notes: notes.present ? notes.value : this.notes,
    isSynced: isSynced ?? this.isSynced,
    createdAt: createdAt ?? this.createdAt,
    lastModified: lastModified ?? this.lastModified,
  );
  FamilyHealthRecord copyWithCompanion(FamilyHealthRecordsCompanion data) {
    return FamilyHealthRecord(
      id: data.id.present ? data.id.value : this.id,
      familyMemberId: data.familyMemberId.present
          ? data.familyMemberId.value
          : this.familyMemberId,
      familyGroupId: data.familyGroupId.present
          ? data.familyGroupId.value
          : this.familyGroupId,
      recordType: data.recordType.present
          ? data.recordType.value
          : this.recordType,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      condition: data.condition.present ? data.condition.value : this.condition,
      symptoms: data.symptoms.present ? data.symptoms.value : this.symptoms,
      severity: data.severity.present ? data.severity.value : this.severity,
      treatment: data.treatment.present ? data.treatment.value : this.treatment,
      medications: data.medications.present
          ? data.medications.value
          : this.medications,
      doctorName: data.doctorName.present
          ? data.doctorName.value
          : this.doctorName,
      hospitalName: data.hospitalName.present
          ? data.hospitalName.value
          : this.hospitalName,
      reportUrl: data.reportUrl.present ? data.reportUrl.value : this.reportUrl,
      attachments: data.attachments.present
          ? data.attachments.value
          : this.attachments,
      recordDate: data.recordDate.present
          ? data.recordDate.value
          : this.recordDate,
      followUpDate: data.followUpDate.present
          ? data.followUpDate.value
          : this.followUpDate,
      isEmergency: data.isEmergency.present
          ? data.isEmergency.value
          : this.isEmergency,
      isResolved: data.isResolved.present
          ? data.isResolved.value
          : this.isResolved,
      notes: data.notes.present ? data.notes.value : this.notes,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      lastModified: data.lastModified.present
          ? data.lastModified.value
          : this.lastModified,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FamilyHealthRecord(')
          ..write('id: $id, ')
          ..write('familyMemberId: $familyMemberId, ')
          ..write('familyGroupId: $familyGroupId, ')
          ..write('recordType: $recordType, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('condition: $condition, ')
          ..write('symptoms: $symptoms, ')
          ..write('severity: $severity, ')
          ..write('treatment: $treatment, ')
          ..write('medications: $medications, ')
          ..write('doctorName: $doctorName, ')
          ..write('hospitalName: $hospitalName, ')
          ..write('reportUrl: $reportUrl, ')
          ..write('attachments: $attachments, ')
          ..write('recordDate: $recordDate, ')
          ..write('followUpDate: $followUpDate, ')
          ..write('isEmergency: $isEmergency, ')
          ..write('isResolved: $isResolved, ')
          ..write('notes: $notes, ')
          ..write('isSynced: $isSynced, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastModified: $lastModified')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    familyMemberId,
    familyGroupId,
    recordType,
    title,
    description,
    condition,
    symptoms,
    severity,
    treatment,
    medications,
    doctorName,
    hospitalName,
    reportUrl,
    attachments,
    recordDate,
    followUpDate,
    isEmergency,
    isResolved,
    notes,
    isSynced,
    createdAt,
    lastModified,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FamilyHealthRecord &&
          other.id == this.id &&
          other.familyMemberId == this.familyMemberId &&
          other.familyGroupId == this.familyGroupId &&
          other.recordType == this.recordType &&
          other.title == this.title &&
          other.description == this.description &&
          other.condition == this.condition &&
          other.symptoms == this.symptoms &&
          other.severity == this.severity &&
          other.treatment == this.treatment &&
          other.medications == this.medications &&
          other.doctorName == this.doctorName &&
          other.hospitalName == this.hospitalName &&
          other.reportUrl == this.reportUrl &&
          other.attachments == this.attachments &&
          other.recordDate == this.recordDate &&
          other.followUpDate == this.followUpDate &&
          other.isEmergency == this.isEmergency &&
          other.isResolved == this.isResolved &&
          other.notes == this.notes &&
          other.isSynced == this.isSynced &&
          other.createdAt == this.createdAt &&
          other.lastModified == this.lastModified);
}

class FamilyHealthRecordsCompanion extends UpdateCompanion<FamilyHealthRecord> {
  final Value<String> id;
  final Value<String> familyMemberId;
  final Value<String> familyGroupId;
  final Value<String> recordType;
  final Value<String> title;
  final Value<String?> description;
  final Value<String?> condition;
  final Value<String?> symptoms;
  final Value<String> severity;
  final Value<String?> treatment;
  final Value<String?> medications;
  final Value<String?> doctorName;
  final Value<String?> hospitalName;
  final Value<String?> reportUrl;
  final Value<String?> attachments;
  final Value<DateTime> recordDate;
  final Value<DateTime?> followUpDate;
  final Value<bool> isEmergency;
  final Value<bool> isResolved;
  final Value<String?> notes;
  final Value<bool> isSynced;
  final Value<DateTime> createdAt;
  final Value<DateTime> lastModified;
  final Value<int> rowid;
  const FamilyHealthRecordsCompanion({
    this.id = const Value.absent(),
    this.familyMemberId = const Value.absent(),
    this.familyGroupId = const Value.absent(),
    this.recordType = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.condition = const Value.absent(),
    this.symptoms = const Value.absent(),
    this.severity = const Value.absent(),
    this.treatment = const Value.absent(),
    this.medications = const Value.absent(),
    this.doctorName = const Value.absent(),
    this.hospitalName = const Value.absent(),
    this.reportUrl = const Value.absent(),
    this.attachments = const Value.absent(),
    this.recordDate = const Value.absent(),
    this.followUpDate = const Value.absent(),
    this.isEmergency = const Value.absent(),
    this.isResolved = const Value.absent(),
    this.notes = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastModified = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FamilyHealthRecordsCompanion.insert({
    required String id,
    required String familyMemberId,
    required String familyGroupId,
    required String recordType,
    required String title,
    this.description = const Value.absent(),
    this.condition = const Value.absent(),
    this.symptoms = const Value.absent(),
    this.severity = const Value.absent(),
    this.treatment = const Value.absent(),
    this.medications = const Value.absent(),
    this.doctorName = const Value.absent(),
    this.hospitalName = const Value.absent(),
    this.reportUrl = const Value.absent(),
    this.attachments = const Value.absent(),
    required DateTime recordDate,
    this.followUpDate = const Value.absent(),
    this.isEmergency = const Value.absent(),
    this.isResolved = const Value.absent(),
    this.notes = const Value.absent(),
    this.isSynced = const Value.absent(),
    required DateTime createdAt,
    required DateTime lastModified,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       familyMemberId = Value(familyMemberId),
       familyGroupId = Value(familyGroupId),
       recordType = Value(recordType),
       title = Value(title),
       recordDate = Value(recordDate),
       createdAt = Value(createdAt),
       lastModified = Value(lastModified);
  static Insertable<FamilyHealthRecord> custom({
    Expression<String>? id,
    Expression<String>? familyMemberId,
    Expression<String>? familyGroupId,
    Expression<String>? recordType,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? condition,
    Expression<String>? symptoms,
    Expression<String>? severity,
    Expression<String>? treatment,
    Expression<String>? medications,
    Expression<String>? doctorName,
    Expression<String>? hospitalName,
    Expression<String>? reportUrl,
    Expression<String>? attachments,
    Expression<DateTime>? recordDate,
    Expression<DateTime>? followUpDate,
    Expression<bool>? isEmergency,
    Expression<bool>? isResolved,
    Expression<String>? notes,
    Expression<bool>? isSynced,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? lastModified,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (familyMemberId != null) 'family_member_id': familyMemberId,
      if (familyGroupId != null) 'family_group_id': familyGroupId,
      if (recordType != null) 'record_type': recordType,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (condition != null) 'condition': condition,
      if (symptoms != null) 'symptoms': symptoms,
      if (severity != null) 'severity': severity,
      if (treatment != null) 'treatment': treatment,
      if (medications != null) 'medications': medications,
      if (doctorName != null) 'doctor_name': doctorName,
      if (hospitalName != null) 'hospital_name': hospitalName,
      if (reportUrl != null) 'report_url': reportUrl,
      if (attachments != null) 'attachments': attachments,
      if (recordDate != null) 'record_date': recordDate,
      if (followUpDate != null) 'follow_up_date': followUpDate,
      if (isEmergency != null) 'is_emergency': isEmergency,
      if (isResolved != null) 'is_resolved': isResolved,
      if (notes != null) 'notes': notes,
      if (isSynced != null) 'is_synced': isSynced,
      if (createdAt != null) 'created_at': createdAt,
      if (lastModified != null) 'last_modified': lastModified,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FamilyHealthRecordsCompanion copyWith({
    Value<String>? id,
    Value<String>? familyMemberId,
    Value<String>? familyGroupId,
    Value<String>? recordType,
    Value<String>? title,
    Value<String?>? description,
    Value<String?>? condition,
    Value<String?>? symptoms,
    Value<String>? severity,
    Value<String?>? treatment,
    Value<String?>? medications,
    Value<String?>? doctorName,
    Value<String?>? hospitalName,
    Value<String?>? reportUrl,
    Value<String?>? attachments,
    Value<DateTime>? recordDate,
    Value<DateTime?>? followUpDate,
    Value<bool>? isEmergency,
    Value<bool>? isResolved,
    Value<String?>? notes,
    Value<bool>? isSynced,
    Value<DateTime>? createdAt,
    Value<DateTime>? lastModified,
    Value<int>? rowid,
  }) {
    return FamilyHealthRecordsCompanion(
      id: id ?? this.id,
      familyMemberId: familyMemberId ?? this.familyMemberId,
      familyGroupId: familyGroupId ?? this.familyGroupId,
      recordType: recordType ?? this.recordType,
      title: title ?? this.title,
      description: description ?? this.description,
      condition: condition ?? this.condition,
      symptoms: symptoms ?? this.symptoms,
      severity: severity ?? this.severity,
      treatment: treatment ?? this.treatment,
      medications: medications ?? this.medications,
      doctorName: doctorName ?? this.doctorName,
      hospitalName: hospitalName ?? this.hospitalName,
      reportUrl: reportUrl ?? this.reportUrl,
      attachments: attachments ?? this.attachments,
      recordDate: recordDate ?? this.recordDate,
      followUpDate: followUpDate ?? this.followUpDate,
      isEmergency: isEmergency ?? this.isEmergency,
      isResolved: isResolved ?? this.isResolved,
      notes: notes ?? this.notes,
      isSynced: isSynced ?? this.isSynced,
      createdAt: createdAt ?? this.createdAt,
      lastModified: lastModified ?? this.lastModified,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (familyMemberId.present) {
      map['family_member_id'] = Variable<String>(familyMemberId.value);
    }
    if (familyGroupId.present) {
      map['family_group_id'] = Variable<String>(familyGroupId.value);
    }
    if (recordType.present) {
      map['record_type'] = Variable<String>(recordType.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (condition.present) {
      map['condition'] = Variable<String>(condition.value);
    }
    if (symptoms.present) {
      map['symptoms'] = Variable<String>(symptoms.value);
    }
    if (severity.present) {
      map['severity'] = Variable<String>(severity.value);
    }
    if (treatment.present) {
      map['treatment'] = Variable<String>(treatment.value);
    }
    if (medications.present) {
      map['medications'] = Variable<String>(medications.value);
    }
    if (doctorName.present) {
      map['doctor_name'] = Variable<String>(doctorName.value);
    }
    if (hospitalName.present) {
      map['hospital_name'] = Variable<String>(hospitalName.value);
    }
    if (reportUrl.present) {
      map['report_url'] = Variable<String>(reportUrl.value);
    }
    if (attachments.present) {
      map['attachments'] = Variable<String>(attachments.value);
    }
    if (recordDate.present) {
      map['record_date'] = Variable<DateTime>(recordDate.value);
    }
    if (followUpDate.present) {
      map['follow_up_date'] = Variable<DateTime>(followUpDate.value);
    }
    if (isEmergency.present) {
      map['is_emergency'] = Variable<bool>(isEmergency.value);
    }
    if (isResolved.present) {
      map['is_resolved'] = Variable<bool>(isResolved.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (lastModified.present) {
      map['last_modified'] = Variable<DateTime>(lastModified.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FamilyHealthRecordsCompanion(')
          ..write('id: $id, ')
          ..write('familyMemberId: $familyMemberId, ')
          ..write('familyGroupId: $familyGroupId, ')
          ..write('recordType: $recordType, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('condition: $condition, ')
          ..write('symptoms: $symptoms, ')
          ..write('severity: $severity, ')
          ..write('treatment: $treatment, ')
          ..write('medications: $medications, ')
          ..write('doctorName: $doctorName, ')
          ..write('hospitalName: $hospitalName, ')
          ..write('reportUrl: $reportUrl, ')
          ..write('attachments: $attachments, ')
          ..write('recordDate: $recordDate, ')
          ..write('followUpDate: $followUpDate, ')
          ..write('isEmergency: $isEmergency, ')
          ..write('isResolved: $isResolved, ')
          ..write('notes: $notes, ')
          ..write('isSynced: $isSynced, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastModified: $lastModified, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CaregiverSessionsTable extends CaregiverSessions
    with TableInfo<$CaregiverSessionsTable, CaregiverSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CaregiverSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _caregiverIdMeta = const VerificationMeta(
    'caregiverId',
  );
  @override
  late final GeneratedColumn<String> caregiverId = GeneratedColumn<String>(
    'caregiver_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dependentIdMeta = const VerificationMeta(
    'dependentId',
  );
  @override
  late final GeneratedColumn<String> dependentId = GeneratedColumn<String>(
    'dependent_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startTimeMeta = const VerificationMeta(
    'startTime',
  );
  @override
  late final GeneratedColumn<DateTime> startTime = GeneratedColumn<DateTime>(
    'start_time',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endTimeMeta = const VerificationMeta(
    'endTime',
  );
  @override
  late final GeneratedColumn<DateTime> endTime = GeneratedColumn<DateTime>(
    'end_time',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _activatedFeaturesMeta = const VerificationMeta(
    'activatedFeatures',
  );
  @override
  late final GeneratedColumn<String> activatedFeatures =
      GeneratedColumn<String>(
        'activated_features',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _actionsPerformedMeta = const VerificationMeta(
    'actionsPerformed',
  );
  @override
  late final GeneratedColumn<String> actionsPerformed = GeneratedColumn<String>(
    'actions_performed',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    caregiverId,
    dependentId,
    startTime,
    endTime,
    activatedFeatures,
    actionsPerformed,
    isActive,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'caregiver_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<CaregiverSession> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('caregiver_id')) {
      context.handle(
        _caregiverIdMeta,
        caregiverId.isAcceptableOrUnknown(
          data['caregiver_id']!,
          _caregiverIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_caregiverIdMeta);
    }
    if (data.containsKey('dependent_id')) {
      context.handle(
        _dependentIdMeta,
        dependentId.isAcceptableOrUnknown(
          data['dependent_id']!,
          _dependentIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dependentIdMeta);
    }
    if (data.containsKey('start_time')) {
      context.handle(
        _startTimeMeta,
        startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_startTimeMeta);
    }
    if (data.containsKey('end_time')) {
      context.handle(
        _endTimeMeta,
        endTime.isAcceptableOrUnknown(data['end_time']!, _endTimeMeta),
      );
    }
    if (data.containsKey('activated_features')) {
      context.handle(
        _activatedFeaturesMeta,
        activatedFeatures.isAcceptableOrUnknown(
          data['activated_features']!,
          _activatedFeaturesMeta,
        ),
      );
    }
    if (data.containsKey('actions_performed')) {
      context.handle(
        _actionsPerformedMeta,
        actionsPerformed.isAcceptableOrUnknown(
          data['actions_performed']!,
          _actionsPerformedMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CaregiverSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CaregiverSession(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      caregiverId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}caregiver_id'],
      )!,
      dependentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dependent_id'],
      )!,
      startTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_time'],
      )!,
      endTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_time'],
      ),
      activatedFeatures: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}activated_features'],
      ),
      actionsPerformed: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}actions_performed'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $CaregiverSessionsTable createAlias(String alias) {
    return $CaregiverSessionsTable(attachedDatabase, alias);
  }
}

class CaregiverSession extends DataClass
    implements Insertable<CaregiverSession> {
  final String id;
  final String caregiverId;
  final String dependentId;
  final DateTime startTime;
  final DateTime? endTime;
  final String? activatedFeatures;
  final String? actionsPerformed;
  final bool isActive;
  final DateTime createdAt;
  const CaregiverSession({
    required this.id,
    required this.caregiverId,
    required this.dependentId,
    required this.startTime,
    this.endTime,
    this.activatedFeatures,
    this.actionsPerformed,
    required this.isActive,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['caregiver_id'] = Variable<String>(caregiverId);
    map['dependent_id'] = Variable<String>(dependentId);
    map['start_time'] = Variable<DateTime>(startTime);
    if (!nullToAbsent || endTime != null) {
      map['end_time'] = Variable<DateTime>(endTime);
    }
    if (!nullToAbsent || activatedFeatures != null) {
      map['activated_features'] = Variable<String>(activatedFeatures);
    }
    if (!nullToAbsent || actionsPerformed != null) {
      map['actions_performed'] = Variable<String>(actionsPerformed);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CaregiverSessionsCompanion toCompanion(bool nullToAbsent) {
    return CaregiverSessionsCompanion(
      id: Value(id),
      caregiverId: Value(caregiverId),
      dependentId: Value(dependentId),
      startTime: Value(startTime),
      endTime: endTime == null && nullToAbsent
          ? const Value.absent()
          : Value(endTime),
      activatedFeatures: activatedFeatures == null && nullToAbsent
          ? const Value.absent()
          : Value(activatedFeatures),
      actionsPerformed: actionsPerformed == null && nullToAbsent
          ? const Value.absent()
          : Value(actionsPerformed),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
    );
  }

  factory CaregiverSession.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CaregiverSession(
      id: serializer.fromJson<String>(json['id']),
      caregiverId: serializer.fromJson<String>(json['caregiverId']),
      dependentId: serializer.fromJson<String>(json['dependentId']),
      startTime: serializer.fromJson<DateTime>(json['startTime']),
      endTime: serializer.fromJson<DateTime?>(json['endTime']),
      activatedFeatures: serializer.fromJson<String?>(
        json['activatedFeatures'],
      ),
      actionsPerformed: serializer.fromJson<String?>(json['actionsPerformed']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'caregiverId': serializer.toJson<String>(caregiverId),
      'dependentId': serializer.toJson<String>(dependentId),
      'startTime': serializer.toJson<DateTime>(startTime),
      'endTime': serializer.toJson<DateTime?>(endTime),
      'activatedFeatures': serializer.toJson<String?>(activatedFeatures),
      'actionsPerformed': serializer.toJson<String?>(actionsPerformed),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  CaregiverSession copyWith({
    String? id,
    String? caregiverId,
    String? dependentId,
    DateTime? startTime,
    Value<DateTime?> endTime = const Value.absent(),
    Value<String?> activatedFeatures = const Value.absent(),
    Value<String?> actionsPerformed = const Value.absent(),
    bool? isActive,
    DateTime? createdAt,
  }) => CaregiverSession(
    id: id ?? this.id,
    caregiverId: caregiverId ?? this.caregiverId,
    dependentId: dependentId ?? this.dependentId,
    startTime: startTime ?? this.startTime,
    endTime: endTime.present ? endTime.value : this.endTime,
    activatedFeatures: activatedFeatures.present
        ? activatedFeatures.value
        : this.activatedFeatures,
    actionsPerformed: actionsPerformed.present
        ? actionsPerformed.value
        : this.actionsPerformed,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
  );
  CaregiverSession copyWithCompanion(CaregiverSessionsCompanion data) {
    return CaregiverSession(
      id: data.id.present ? data.id.value : this.id,
      caregiverId: data.caregiverId.present
          ? data.caregiverId.value
          : this.caregiverId,
      dependentId: data.dependentId.present
          ? data.dependentId.value
          : this.dependentId,
      startTime: data.startTime.present ? data.startTime.value : this.startTime,
      endTime: data.endTime.present ? data.endTime.value : this.endTime,
      activatedFeatures: data.activatedFeatures.present
          ? data.activatedFeatures.value
          : this.activatedFeatures,
      actionsPerformed: data.actionsPerformed.present
          ? data.actionsPerformed.value
          : this.actionsPerformed,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CaregiverSession(')
          ..write('id: $id, ')
          ..write('caregiverId: $caregiverId, ')
          ..write('dependentId: $dependentId, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('activatedFeatures: $activatedFeatures, ')
          ..write('actionsPerformed: $actionsPerformed, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    caregiverId,
    dependentId,
    startTime,
    endTime,
    activatedFeatures,
    actionsPerformed,
    isActive,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CaregiverSession &&
          other.id == this.id &&
          other.caregiverId == this.caregiverId &&
          other.dependentId == this.dependentId &&
          other.startTime == this.startTime &&
          other.endTime == this.endTime &&
          other.activatedFeatures == this.activatedFeatures &&
          other.actionsPerformed == this.actionsPerformed &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt);
}

class CaregiverSessionsCompanion extends UpdateCompanion<CaregiverSession> {
  final Value<String> id;
  final Value<String> caregiverId;
  final Value<String> dependentId;
  final Value<DateTime> startTime;
  final Value<DateTime?> endTime;
  final Value<String?> activatedFeatures;
  final Value<String?> actionsPerformed;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const CaregiverSessionsCompanion({
    this.id = const Value.absent(),
    this.caregiverId = const Value.absent(),
    this.dependentId = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.activatedFeatures = const Value.absent(),
    this.actionsPerformed = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CaregiverSessionsCompanion.insert({
    required String id,
    required String caregiverId,
    required String dependentId,
    required DateTime startTime,
    this.endTime = const Value.absent(),
    this.activatedFeatures = const Value.absent(),
    this.actionsPerformed = const Value.absent(),
    this.isActive = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       caregiverId = Value(caregiverId),
       dependentId = Value(dependentId),
       startTime = Value(startTime),
       createdAt = Value(createdAt);
  static Insertable<CaregiverSession> custom({
    Expression<String>? id,
    Expression<String>? caregiverId,
    Expression<String>? dependentId,
    Expression<DateTime>? startTime,
    Expression<DateTime>? endTime,
    Expression<String>? activatedFeatures,
    Expression<String>? actionsPerformed,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (caregiverId != null) 'caregiver_id': caregiverId,
      if (dependentId != null) 'dependent_id': dependentId,
      if (startTime != null) 'start_time': startTime,
      if (endTime != null) 'end_time': endTime,
      if (activatedFeatures != null) 'activated_features': activatedFeatures,
      if (actionsPerformed != null) 'actions_performed': actionsPerformed,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CaregiverSessionsCompanion copyWith({
    Value<String>? id,
    Value<String>? caregiverId,
    Value<String>? dependentId,
    Value<DateTime>? startTime,
    Value<DateTime?>? endTime,
    Value<String?>? activatedFeatures,
    Value<String?>? actionsPerformed,
    Value<bool>? isActive,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return CaregiverSessionsCompanion(
      id: id ?? this.id,
      caregiverId: caregiverId ?? this.caregiverId,
      dependentId: dependentId ?? this.dependentId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      activatedFeatures: activatedFeatures ?? this.activatedFeatures,
      actionsPerformed: actionsPerformed ?? this.actionsPerformed,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (caregiverId.present) {
      map['caregiver_id'] = Variable<String>(caregiverId.value);
    }
    if (dependentId.present) {
      map['dependent_id'] = Variable<String>(dependentId.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<DateTime>(startTime.value);
    }
    if (endTime.present) {
      map['end_time'] = Variable<DateTime>(endTime.value);
    }
    if (activatedFeatures.present) {
      map['activated_features'] = Variable<String>(activatedFeatures.value);
    }
    if (actionsPerformed.present) {
      map['actions_performed'] = Variable<String>(actionsPerformed.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CaregiverSessionsCompanion(')
          ..write('id: $id, ')
          ..write('caregiverId: $caregiverId, ')
          ..write('dependentId: $dependentId, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('activatedFeatures: $activatedFeatures, ')
          ..write('actionsPerformed: $actionsPerformed, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$OfflineDatabase extends GeneratedDatabase {
  _$OfflineDatabase(QueryExecutor e) : super(e);
  $OfflineDatabaseManager get managers => $OfflineDatabaseManager(this);
  late final $PatientProfilesTable patientProfiles = $PatientProfilesTable(
    this,
  );
  late final $UserProfilesTable userProfiles = $UserProfilesTable(this);
  late final $OfflineAppointmentsTable offlineAppointments =
      $OfflineAppointmentsTable(this);
  late final $CachedPrescriptionsTable cachedPrescriptions =
      $CachedPrescriptionsTable(this);
  late final $OfflineSymptomChecksTable offlineSymptomChecks =
      $OfflineSymptomChecksTable(this);
  late final $SyncQueuesTable syncQueues = $SyncQueuesTable(this);
  late final $MedicalReportsTable medicalReports = $MedicalReportsTable(this);
  late final $VitalSignsTable vitalSigns = $VitalSignsTable(this);
  late final $FamilyMembersTable familyMembers = $FamilyMembersTable(this);
  late final $FamilyGroupsTable familyGroups = $FamilyGroupsTable(this);
  late final $FamilyHealthRecordsTable familyHealthRecords =
      $FamilyHealthRecordsTable(this);
  late final $CaregiverSessionsTable caregiverSessions =
      $CaregiverSessionsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    patientProfiles,
    userProfiles,
    offlineAppointments,
    cachedPrescriptions,
    offlineSymptomChecks,
    syncQueues,
    medicalReports,
    vitalSigns,
    familyMembers,
    familyGroups,
    familyHealthRecords,
    caregiverSessions,
  ];
}

typedef $$PatientProfilesTableCreateCompanionBuilder =
    PatientProfilesCompanion Function({
      required String id,
      required String name,
      required String age,
      required String gender,
      required String phone,
      required String email,
      Value<String?> medicalHistory,
      Value<String?> profileImage,
      Value<bool> isOnline,
      Value<DateTime?> lastSynced,
      required DateTime lastModified,
      Value<int> rowid,
    });
typedef $$PatientProfilesTableUpdateCompanionBuilder =
    PatientProfilesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> age,
      Value<String> gender,
      Value<String> phone,
      Value<String> email,
      Value<String?> medicalHistory,
      Value<String?> profileImage,
      Value<bool> isOnline,
      Value<DateTime?> lastSynced,
      Value<DateTime> lastModified,
      Value<int> rowid,
    });

class $$PatientProfilesTableFilterComposer
    extends Composer<_$OfflineDatabase, $PatientProfilesTable> {
  $$PatientProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get age => $composableBuilder(
    column: $table.age,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get medicalHistory => $composableBuilder(
    column: $table.medicalHistory,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get profileImage => $composableBuilder(
    column: $table.profileImage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isOnline => $composableBuilder(
    column: $table.isOnline,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSynced => $composableBuilder(
    column: $table.lastSynced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastModified => $composableBuilder(
    column: $table.lastModified,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PatientProfilesTableOrderingComposer
    extends Composer<_$OfflineDatabase, $PatientProfilesTable> {
  $$PatientProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get age => $composableBuilder(
    column: $table.age,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get medicalHistory => $composableBuilder(
    column: $table.medicalHistory,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get profileImage => $composableBuilder(
    column: $table.profileImage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isOnline => $composableBuilder(
    column: $table.isOnline,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSynced => $composableBuilder(
    column: $table.lastSynced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastModified => $composableBuilder(
    column: $table.lastModified,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PatientProfilesTableAnnotationComposer
    extends Composer<_$OfflineDatabase, $PatientProfilesTable> {
  $$PatientProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get age =>
      $composableBuilder(column: $table.age, builder: (column) => column);

  GeneratedColumn<String> get gender =>
      $composableBuilder(column: $table.gender, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get medicalHistory => $composableBuilder(
    column: $table.medicalHistory,
    builder: (column) => column,
  );

  GeneratedColumn<String> get profileImage => $composableBuilder(
    column: $table.profileImage,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isOnline =>
      $composableBuilder(column: $table.isOnline, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSynced => $composableBuilder(
    column: $table.lastSynced,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastModified => $composableBuilder(
    column: $table.lastModified,
    builder: (column) => column,
  );
}

class $$PatientProfilesTableTableManager
    extends
        RootTableManager<
          _$OfflineDatabase,
          $PatientProfilesTable,
          PatientProfile,
          $$PatientProfilesTableFilterComposer,
          $$PatientProfilesTableOrderingComposer,
          $$PatientProfilesTableAnnotationComposer,
          $$PatientProfilesTableCreateCompanionBuilder,
          $$PatientProfilesTableUpdateCompanionBuilder,
          (
            PatientProfile,
            BaseReferences<
              _$OfflineDatabase,
              $PatientProfilesTable,
              PatientProfile
            >,
          ),
          PatientProfile,
          PrefetchHooks Function()
        > {
  $$PatientProfilesTableTableManager(
    _$OfflineDatabase db,
    $PatientProfilesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PatientProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PatientProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PatientProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> age = const Value.absent(),
                Value<String> gender = const Value.absent(),
                Value<String> phone = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String?> medicalHistory = const Value.absent(),
                Value<String?> profileImage = const Value.absent(),
                Value<bool> isOnline = const Value.absent(),
                Value<DateTime?> lastSynced = const Value.absent(),
                Value<DateTime> lastModified = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PatientProfilesCompanion(
                id: id,
                name: name,
                age: age,
                gender: gender,
                phone: phone,
                email: email,
                medicalHistory: medicalHistory,
                profileImage: profileImage,
                isOnline: isOnline,
                lastSynced: lastSynced,
                lastModified: lastModified,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String age,
                required String gender,
                required String phone,
                required String email,
                Value<String?> medicalHistory = const Value.absent(),
                Value<String?> profileImage = const Value.absent(),
                Value<bool> isOnline = const Value.absent(),
                Value<DateTime?> lastSynced = const Value.absent(),
                required DateTime lastModified,
                Value<int> rowid = const Value.absent(),
              }) => PatientProfilesCompanion.insert(
                id: id,
                name: name,
                age: age,
                gender: gender,
                phone: phone,
                email: email,
                medicalHistory: medicalHistory,
                profileImage: profileImage,
                isOnline: isOnline,
                lastSynced: lastSynced,
                lastModified: lastModified,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PatientProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$OfflineDatabase,
      $PatientProfilesTable,
      PatientProfile,
      $$PatientProfilesTableFilterComposer,
      $$PatientProfilesTableOrderingComposer,
      $$PatientProfilesTableAnnotationComposer,
      $$PatientProfilesTableCreateCompanionBuilder,
      $$PatientProfilesTableUpdateCompanionBuilder,
      (
        PatientProfile,
        BaseReferences<
          _$OfflineDatabase,
          $PatientProfilesTable,
          PatientProfile
        >,
      ),
      PatientProfile,
      PrefetchHooks Function()
    >;
typedef $$UserProfilesTableCreateCompanionBuilder =
    UserProfilesCompanion Function({
      required String id,
      required String phoneNumber,
      required String passwordHash,
      required String fullName,
      Value<String?> email,
      Value<bool> isVerified,
      Value<bool> isActive,
      Value<bool> isSynced,
      required DateTime createdAt,
      required DateTime lastModified,
      Value<int> rowid,
    });
typedef $$UserProfilesTableUpdateCompanionBuilder =
    UserProfilesCompanion Function({
      Value<String> id,
      Value<String> phoneNumber,
      Value<String> passwordHash,
      Value<String> fullName,
      Value<String?> email,
      Value<bool> isVerified,
      Value<bool> isActive,
      Value<bool> isSynced,
      Value<DateTime> createdAt,
      Value<DateTime> lastModified,
      Value<int> rowid,
    });

class $$UserProfilesTableFilterComposer
    extends Composer<_$OfflineDatabase, $UserProfilesTable> {
  $$UserProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get passwordHash => $composableBuilder(
    column: $table.passwordHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isVerified => $composableBuilder(
    column: $table.isVerified,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastModified => $composableBuilder(
    column: $table.lastModified,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserProfilesTableOrderingComposer
    extends Composer<_$OfflineDatabase, $UserProfilesTable> {
  $$UserProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get passwordHash => $composableBuilder(
    column: $table.passwordHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isVerified => $composableBuilder(
    column: $table.isVerified,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastModified => $composableBuilder(
    column: $table.lastModified,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserProfilesTableAnnotationComposer
    extends Composer<_$OfflineDatabase, $UserProfilesTable> {
  $$UserProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get passwordHash => $composableBuilder(
    column: $table.passwordHash,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fullName =>
      $composableBuilder(column: $table.fullName, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<bool> get isVerified => $composableBuilder(
    column: $table.isVerified,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastModified => $composableBuilder(
    column: $table.lastModified,
    builder: (column) => column,
  );
}

class $$UserProfilesTableTableManager
    extends
        RootTableManager<
          _$OfflineDatabase,
          $UserProfilesTable,
          UserProfile,
          $$UserProfilesTableFilterComposer,
          $$UserProfilesTableOrderingComposer,
          $$UserProfilesTableAnnotationComposer,
          $$UserProfilesTableCreateCompanionBuilder,
          $$UserProfilesTableUpdateCompanionBuilder,
          (
            UserProfile,
            BaseReferences<_$OfflineDatabase, $UserProfilesTable, UserProfile>,
          ),
          UserProfile,
          PrefetchHooks Function()
        > {
  $$UserProfilesTableTableManager(
    _$OfflineDatabase db,
    $UserProfilesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> phoneNumber = const Value.absent(),
                Value<String> passwordHash = const Value.absent(),
                Value<String> fullName = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<bool> isVerified = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> lastModified = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserProfilesCompanion(
                id: id,
                phoneNumber: phoneNumber,
                passwordHash: passwordHash,
                fullName: fullName,
                email: email,
                isVerified: isVerified,
                isActive: isActive,
                isSynced: isSynced,
                createdAt: createdAt,
                lastModified: lastModified,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String phoneNumber,
                required String passwordHash,
                required String fullName,
                Value<String?> email = const Value.absent(),
                Value<bool> isVerified = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                required DateTime createdAt,
                required DateTime lastModified,
                Value<int> rowid = const Value.absent(),
              }) => UserProfilesCompanion.insert(
                id: id,
                phoneNumber: phoneNumber,
                passwordHash: passwordHash,
                fullName: fullName,
                email: email,
                isVerified: isVerified,
                isActive: isActive,
                isSynced: isSynced,
                createdAt: createdAt,
                lastModified: lastModified,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$OfflineDatabase,
      $UserProfilesTable,
      UserProfile,
      $$UserProfilesTableFilterComposer,
      $$UserProfilesTableOrderingComposer,
      $$UserProfilesTableAnnotationComposer,
      $$UserProfilesTableCreateCompanionBuilder,
      $$UserProfilesTableUpdateCompanionBuilder,
      (
        UserProfile,
        BaseReferences<_$OfflineDatabase, $UserProfilesTable, UserProfile>,
      ),
      UserProfile,
      PrefetchHooks Function()
    >;
typedef $$OfflineAppointmentsTableCreateCompanionBuilder =
    OfflineAppointmentsCompanion Function({
      required String id,
      required String patientId,
      required String patientName,
      required String patientAge,
      required String patientGender,
      required String symptoms,
      Value<String?> medicalHistory,
      required String preferredTime,
      Value<String> priority,
      Value<String> status,
      Value<String?> doctorId,
      required DateTime createdAt,
      required DateTime lastModified,
      Value<bool> isSynced,
      Value<bool> isDeleted,
      Value<int> rowid,
    });
typedef $$OfflineAppointmentsTableUpdateCompanionBuilder =
    OfflineAppointmentsCompanion Function({
      Value<String> id,
      Value<String> patientId,
      Value<String> patientName,
      Value<String> patientAge,
      Value<String> patientGender,
      Value<String> symptoms,
      Value<String?> medicalHistory,
      Value<String> preferredTime,
      Value<String> priority,
      Value<String> status,
      Value<String?> doctorId,
      Value<DateTime> createdAt,
      Value<DateTime> lastModified,
      Value<bool> isSynced,
      Value<bool> isDeleted,
      Value<int> rowid,
    });

class $$OfflineAppointmentsTableFilterComposer
    extends Composer<_$OfflineDatabase, $OfflineAppointmentsTable> {
  $$OfflineAppointmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get patientId => $composableBuilder(
    column: $table.patientId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get patientName => $composableBuilder(
    column: $table.patientName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get patientAge => $composableBuilder(
    column: $table.patientAge,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get patientGender => $composableBuilder(
    column: $table.patientGender,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get symptoms => $composableBuilder(
    column: $table.symptoms,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get medicalHistory => $composableBuilder(
    column: $table.medicalHistory,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get preferredTime => $composableBuilder(
    column: $table.preferredTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get doctorId => $composableBuilder(
    column: $table.doctorId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastModified => $composableBuilder(
    column: $table.lastModified,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OfflineAppointmentsTableOrderingComposer
    extends Composer<_$OfflineDatabase, $OfflineAppointmentsTable> {
  $$OfflineAppointmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get patientId => $composableBuilder(
    column: $table.patientId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get patientName => $composableBuilder(
    column: $table.patientName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get patientAge => $composableBuilder(
    column: $table.patientAge,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get patientGender => $composableBuilder(
    column: $table.patientGender,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get symptoms => $composableBuilder(
    column: $table.symptoms,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get medicalHistory => $composableBuilder(
    column: $table.medicalHistory,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get preferredTime => $composableBuilder(
    column: $table.preferredTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get doctorId => $composableBuilder(
    column: $table.doctorId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastModified => $composableBuilder(
    column: $table.lastModified,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OfflineAppointmentsTableAnnotationComposer
    extends Composer<_$OfflineDatabase, $OfflineAppointmentsTable> {
  $$OfflineAppointmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get patientId =>
      $composableBuilder(column: $table.patientId, builder: (column) => column);

  GeneratedColumn<String> get patientName => $composableBuilder(
    column: $table.patientName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get patientAge => $composableBuilder(
    column: $table.patientAge,
    builder: (column) => column,
  );

  GeneratedColumn<String> get patientGender => $composableBuilder(
    column: $table.patientGender,
    builder: (column) => column,
  );

  GeneratedColumn<String> get symptoms =>
      $composableBuilder(column: $table.symptoms, builder: (column) => column);

  GeneratedColumn<String> get medicalHistory => $composableBuilder(
    column: $table.medicalHistory,
    builder: (column) => column,
  );

  GeneratedColumn<String> get preferredTime => $composableBuilder(
    column: $table.preferredTime,
    builder: (column) => column,
  );

  GeneratedColumn<String> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get doctorId =>
      $composableBuilder(column: $table.doctorId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastModified => $composableBuilder(
    column: $table.lastModified,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);
}

class $$OfflineAppointmentsTableTableManager
    extends
        RootTableManager<
          _$OfflineDatabase,
          $OfflineAppointmentsTable,
          OfflineAppointment,
          $$OfflineAppointmentsTableFilterComposer,
          $$OfflineAppointmentsTableOrderingComposer,
          $$OfflineAppointmentsTableAnnotationComposer,
          $$OfflineAppointmentsTableCreateCompanionBuilder,
          $$OfflineAppointmentsTableUpdateCompanionBuilder,
          (
            OfflineAppointment,
            BaseReferences<
              _$OfflineDatabase,
              $OfflineAppointmentsTable,
              OfflineAppointment
            >,
          ),
          OfflineAppointment,
          PrefetchHooks Function()
        > {
  $$OfflineAppointmentsTableTableManager(
    _$OfflineDatabase db,
    $OfflineAppointmentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OfflineAppointmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OfflineAppointmentsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$OfflineAppointmentsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> patientId = const Value.absent(),
                Value<String> patientName = const Value.absent(),
                Value<String> patientAge = const Value.absent(),
                Value<String> patientGender = const Value.absent(),
                Value<String> symptoms = const Value.absent(),
                Value<String?> medicalHistory = const Value.absent(),
                Value<String> preferredTime = const Value.absent(),
                Value<String> priority = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> doctorId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> lastModified = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OfflineAppointmentsCompanion(
                id: id,
                patientId: patientId,
                patientName: patientName,
                patientAge: patientAge,
                patientGender: patientGender,
                symptoms: symptoms,
                medicalHistory: medicalHistory,
                preferredTime: preferredTime,
                priority: priority,
                status: status,
                doctorId: doctorId,
                createdAt: createdAt,
                lastModified: lastModified,
                isSynced: isSynced,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String patientId,
                required String patientName,
                required String patientAge,
                required String patientGender,
                required String symptoms,
                Value<String?> medicalHistory = const Value.absent(),
                required String preferredTime,
                Value<String> priority = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> doctorId = const Value.absent(),
                required DateTime createdAt,
                required DateTime lastModified,
                Value<bool> isSynced = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OfflineAppointmentsCompanion.insert(
                id: id,
                patientId: patientId,
                patientName: patientName,
                patientAge: patientAge,
                patientGender: patientGender,
                symptoms: symptoms,
                medicalHistory: medicalHistory,
                preferredTime: preferredTime,
                priority: priority,
                status: status,
                doctorId: doctorId,
                createdAt: createdAt,
                lastModified: lastModified,
                isSynced: isSynced,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OfflineAppointmentsTableProcessedTableManager =
    ProcessedTableManager<
      _$OfflineDatabase,
      $OfflineAppointmentsTable,
      OfflineAppointment,
      $$OfflineAppointmentsTableFilterComposer,
      $$OfflineAppointmentsTableOrderingComposer,
      $$OfflineAppointmentsTableAnnotationComposer,
      $$OfflineAppointmentsTableCreateCompanionBuilder,
      $$OfflineAppointmentsTableUpdateCompanionBuilder,
      (
        OfflineAppointment,
        BaseReferences<
          _$OfflineDatabase,
          $OfflineAppointmentsTable,
          OfflineAppointment
        >,
      ),
      OfflineAppointment,
      PrefetchHooks Function()
    >;
typedef $$CachedPrescriptionsTableCreateCompanionBuilder =
    CachedPrescriptionsCompanion Function({
      required String id,
      required String appointmentId,
      required String patientId,
      required String doctorId,
      required String doctorName,
      required String medications,
      required String dosage,
      required String instructions,
      required String duration,
      required DateTime prescribedAt,
      required DateTime cachedAt,
      Value<bool> isOfflineAccessed,
      Value<int> rowid,
    });
typedef $$CachedPrescriptionsTableUpdateCompanionBuilder =
    CachedPrescriptionsCompanion Function({
      Value<String> id,
      Value<String> appointmentId,
      Value<String> patientId,
      Value<String> doctorId,
      Value<String> doctorName,
      Value<String> medications,
      Value<String> dosage,
      Value<String> instructions,
      Value<String> duration,
      Value<DateTime> prescribedAt,
      Value<DateTime> cachedAt,
      Value<bool> isOfflineAccessed,
      Value<int> rowid,
    });

class $$CachedPrescriptionsTableFilterComposer
    extends Composer<_$OfflineDatabase, $CachedPrescriptionsTable> {
  $$CachedPrescriptionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get appointmentId => $composableBuilder(
    column: $table.appointmentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get patientId => $composableBuilder(
    column: $table.patientId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get doctorId => $composableBuilder(
    column: $table.doctorId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get doctorName => $composableBuilder(
    column: $table.doctorName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get medications => $composableBuilder(
    column: $table.medications,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dosage => $composableBuilder(
    column: $table.dosage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get instructions => $composableBuilder(
    column: $table.instructions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get duration => $composableBuilder(
    column: $table.duration,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get prescribedAt => $composableBuilder(
    column: $table.prescribedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isOfflineAccessed => $composableBuilder(
    column: $table.isOfflineAccessed,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedPrescriptionsTableOrderingComposer
    extends Composer<_$OfflineDatabase, $CachedPrescriptionsTable> {
  $$CachedPrescriptionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get appointmentId => $composableBuilder(
    column: $table.appointmentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get patientId => $composableBuilder(
    column: $table.patientId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get doctorId => $composableBuilder(
    column: $table.doctorId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get doctorName => $composableBuilder(
    column: $table.doctorName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get medications => $composableBuilder(
    column: $table.medications,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dosage => $composableBuilder(
    column: $table.dosage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get instructions => $composableBuilder(
    column: $table.instructions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get duration => $composableBuilder(
    column: $table.duration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get prescribedAt => $composableBuilder(
    column: $table.prescribedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isOfflineAccessed => $composableBuilder(
    column: $table.isOfflineAccessed,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedPrescriptionsTableAnnotationComposer
    extends Composer<_$OfflineDatabase, $CachedPrescriptionsTable> {
  $$CachedPrescriptionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get appointmentId => $composableBuilder(
    column: $table.appointmentId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get patientId =>
      $composableBuilder(column: $table.patientId, builder: (column) => column);

  GeneratedColumn<String> get doctorId =>
      $composableBuilder(column: $table.doctorId, builder: (column) => column);

  GeneratedColumn<String> get doctorName => $composableBuilder(
    column: $table.doctorName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get medications => $composableBuilder(
    column: $table.medications,
    builder: (column) => column,
  );

  GeneratedColumn<String> get dosage =>
      $composableBuilder(column: $table.dosage, builder: (column) => column);

  GeneratedColumn<String> get instructions => $composableBuilder(
    column: $table.instructions,
    builder: (column) => column,
  );

  GeneratedColumn<String> get duration =>
      $composableBuilder(column: $table.duration, builder: (column) => column);

  GeneratedColumn<DateTime> get prescribedAt => $composableBuilder(
    column: $table.prescribedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get cachedAt =>
      $composableBuilder(column: $table.cachedAt, builder: (column) => column);

  GeneratedColumn<bool> get isOfflineAccessed => $composableBuilder(
    column: $table.isOfflineAccessed,
    builder: (column) => column,
  );
}

class $$CachedPrescriptionsTableTableManager
    extends
        RootTableManager<
          _$OfflineDatabase,
          $CachedPrescriptionsTable,
          CachedPrescription,
          $$CachedPrescriptionsTableFilterComposer,
          $$CachedPrescriptionsTableOrderingComposer,
          $$CachedPrescriptionsTableAnnotationComposer,
          $$CachedPrescriptionsTableCreateCompanionBuilder,
          $$CachedPrescriptionsTableUpdateCompanionBuilder,
          (
            CachedPrescription,
            BaseReferences<
              _$OfflineDatabase,
              $CachedPrescriptionsTable,
              CachedPrescription
            >,
          ),
          CachedPrescription,
          PrefetchHooks Function()
        > {
  $$CachedPrescriptionsTableTableManager(
    _$OfflineDatabase db,
    $CachedPrescriptionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedPrescriptionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedPrescriptionsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$CachedPrescriptionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> appointmentId = const Value.absent(),
                Value<String> patientId = const Value.absent(),
                Value<String> doctorId = const Value.absent(),
                Value<String> doctorName = const Value.absent(),
                Value<String> medications = const Value.absent(),
                Value<String> dosage = const Value.absent(),
                Value<String> instructions = const Value.absent(),
                Value<String> duration = const Value.absent(),
                Value<DateTime> prescribedAt = const Value.absent(),
                Value<DateTime> cachedAt = const Value.absent(),
                Value<bool> isOfflineAccessed = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedPrescriptionsCompanion(
                id: id,
                appointmentId: appointmentId,
                patientId: patientId,
                doctorId: doctorId,
                doctorName: doctorName,
                medications: medications,
                dosage: dosage,
                instructions: instructions,
                duration: duration,
                prescribedAt: prescribedAt,
                cachedAt: cachedAt,
                isOfflineAccessed: isOfflineAccessed,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String appointmentId,
                required String patientId,
                required String doctorId,
                required String doctorName,
                required String medications,
                required String dosage,
                required String instructions,
                required String duration,
                required DateTime prescribedAt,
                required DateTime cachedAt,
                Value<bool> isOfflineAccessed = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedPrescriptionsCompanion.insert(
                id: id,
                appointmentId: appointmentId,
                patientId: patientId,
                doctorId: doctorId,
                doctorName: doctorName,
                medications: medications,
                dosage: dosage,
                instructions: instructions,
                duration: duration,
                prescribedAt: prescribedAt,
                cachedAt: cachedAt,
                isOfflineAccessed: isOfflineAccessed,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedPrescriptionsTableProcessedTableManager =
    ProcessedTableManager<
      _$OfflineDatabase,
      $CachedPrescriptionsTable,
      CachedPrescription,
      $$CachedPrescriptionsTableFilterComposer,
      $$CachedPrescriptionsTableOrderingComposer,
      $$CachedPrescriptionsTableAnnotationComposer,
      $$CachedPrescriptionsTableCreateCompanionBuilder,
      $$CachedPrescriptionsTableUpdateCompanionBuilder,
      (
        CachedPrescription,
        BaseReferences<
          _$OfflineDatabase,
          $CachedPrescriptionsTable,
          CachedPrescription
        >,
      ),
      CachedPrescription,
      PrefetchHooks Function()
    >;
typedef $$OfflineSymptomChecksTableCreateCompanionBuilder =
    OfflineSymptomChecksCompanion Function({
      required String id,
      required String patientId,
      required String symptoms,
      required String severity,
      required String recommendations,
      Value<String> language,
      required DateTime checkedAt,
      Value<bool> requiresUrgentCare,
      Value<int> rowid,
    });
typedef $$OfflineSymptomChecksTableUpdateCompanionBuilder =
    OfflineSymptomChecksCompanion Function({
      Value<String> id,
      Value<String> patientId,
      Value<String> symptoms,
      Value<String> severity,
      Value<String> recommendations,
      Value<String> language,
      Value<DateTime> checkedAt,
      Value<bool> requiresUrgentCare,
      Value<int> rowid,
    });

class $$OfflineSymptomChecksTableFilterComposer
    extends Composer<_$OfflineDatabase, $OfflineSymptomChecksTable> {
  $$OfflineSymptomChecksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get patientId => $composableBuilder(
    column: $table.patientId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get symptoms => $composableBuilder(
    column: $table.symptoms,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get severity => $composableBuilder(
    column: $table.severity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recommendations => $composableBuilder(
    column: $table.recommendations,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get checkedAt => $composableBuilder(
    column: $table.checkedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get requiresUrgentCare => $composableBuilder(
    column: $table.requiresUrgentCare,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OfflineSymptomChecksTableOrderingComposer
    extends Composer<_$OfflineDatabase, $OfflineSymptomChecksTable> {
  $$OfflineSymptomChecksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get patientId => $composableBuilder(
    column: $table.patientId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get symptoms => $composableBuilder(
    column: $table.symptoms,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get severity => $composableBuilder(
    column: $table.severity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recommendations => $composableBuilder(
    column: $table.recommendations,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get checkedAt => $composableBuilder(
    column: $table.checkedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get requiresUrgentCare => $composableBuilder(
    column: $table.requiresUrgentCare,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OfflineSymptomChecksTableAnnotationComposer
    extends Composer<_$OfflineDatabase, $OfflineSymptomChecksTable> {
  $$OfflineSymptomChecksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get patientId =>
      $composableBuilder(column: $table.patientId, builder: (column) => column);

  GeneratedColumn<String> get symptoms =>
      $composableBuilder(column: $table.symptoms, builder: (column) => column);

  GeneratedColumn<String> get severity =>
      $composableBuilder(column: $table.severity, builder: (column) => column);

  GeneratedColumn<String> get recommendations => $composableBuilder(
    column: $table.recommendations,
    builder: (column) => column,
  );

  GeneratedColumn<String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => column);

  GeneratedColumn<DateTime> get checkedAt =>
      $composableBuilder(column: $table.checkedAt, builder: (column) => column);

  GeneratedColumn<bool> get requiresUrgentCare => $composableBuilder(
    column: $table.requiresUrgentCare,
    builder: (column) => column,
  );
}

class $$OfflineSymptomChecksTableTableManager
    extends
        RootTableManager<
          _$OfflineDatabase,
          $OfflineSymptomChecksTable,
          OfflineSymptomCheck,
          $$OfflineSymptomChecksTableFilterComposer,
          $$OfflineSymptomChecksTableOrderingComposer,
          $$OfflineSymptomChecksTableAnnotationComposer,
          $$OfflineSymptomChecksTableCreateCompanionBuilder,
          $$OfflineSymptomChecksTableUpdateCompanionBuilder,
          (
            OfflineSymptomCheck,
            BaseReferences<
              _$OfflineDatabase,
              $OfflineSymptomChecksTable,
              OfflineSymptomCheck
            >,
          ),
          OfflineSymptomCheck,
          PrefetchHooks Function()
        > {
  $$OfflineSymptomChecksTableTableManager(
    _$OfflineDatabase db,
    $OfflineSymptomChecksTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OfflineSymptomChecksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OfflineSymptomChecksTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$OfflineSymptomChecksTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> patientId = const Value.absent(),
                Value<String> symptoms = const Value.absent(),
                Value<String> severity = const Value.absent(),
                Value<String> recommendations = const Value.absent(),
                Value<String> language = const Value.absent(),
                Value<DateTime> checkedAt = const Value.absent(),
                Value<bool> requiresUrgentCare = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OfflineSymptomChecksCompanion(
                id: id,
                patientId: patientId,
                symptoms: symptoms,
                severity: severity,
                recommendations: recommendations,
                language: language,
                checkedAt: checkedAt,
                requiresUrgentCare: requiresUrgentCare,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String patientId,
                required String symptoms,
                required String severity,
                required String recommendations,
                Value<String> language = const Value.absent(),
                required DateTime checkedAt,
                Value<bool> requiresUrgentCare = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OfflineSymptomChecksCompanion.insert(
                id: id,
                patientId: patientId,
                symptoms: symptoms,
                severity: severity,
                recommendations: recommendations,
                language: language,
                checkedAt: checkedAt,
                requiresUrgentCare: requiresUrgentCare,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OfflineSymptomChecksTableProcessedTableManager =
    ProcessedTableManager<
      _$OfflineDatabase,
      $OfflineSymptomChecksTable,
      OfflineSymptomCheck,
      $$OfflineSymptomChecksTableFilterComposer,
      $$OfflineSymptomChecksTableOrderingComposer,
      $$OfflineSymptomChecksTableAnnotationComposer,
      $$OfflineSymptomChecksTableCreateCompanionBuilder,
      $$OfflineSymptomChecksTableUpdateCompanionBuilder,
      (
        OfflineSymptomCheck,
        BaseReferences<
          _$OfflineDatabase,
          $OfflineSymptomChecksTable,
          OfflineSymptomCheck
        >,
      ),
      OfflineSymptomCheck,
      PrefetchHooks Function()
    >;
typedef $$SyncQueuesTableCreateCompanionBuilder =
    SyncQueuesCompanion Function({
      required String id,
      required String targetTable,
      required String recordId,
      required String operation,
      required String data,
      Value<int> priority,
      required DateTime createdAt,
      Value<int> retryCount,
      Value<DateTime?> lastAttempt,
      Value<int> rowid,
    });
typedef $$SyncQueuesTableUpdateCompanionBuilder =
    SyncQueuesCompanion Function({
      Value<String> id,
      Value<String> targetTable,
      Value<String> recordId,
      Value<String> operation,
      Value<String> data,
      Value<int> priority,
      Value<DateTime> createdAt,
      Value<int> retryCount,
      Value<DateTime?> lastAttempt,
      Value<int> rowid,
    });

class $$SyncQueuesTableFilterComposer
    extends Composer<_$OfflineDatabase, $SyncQueuesTable> {
  $$SyncQueuesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get targetTable => $composableBuilder(
    column: $table.targetTable,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recordId => $composableBuilder(
    column: $table.recordId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get data => $composableBuilder(
    column: $table.data,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastAttempt => $composableBuilder(
    column: $table.lastAttempt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncQueuesTableOrderingComposer
    extends Composer<_$OfflineDatabase, $SyncQueuesTable> {
  $$SyncQueuesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetTable => $composableBuilder(
    column: $table.targetTable,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recordId => $composableBuilder(
    column: $table.recordId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get data => $composableBuilder(
    column: $table.data,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastAttempt => $composableBuilder(
    column: $table.lastAttempt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncQueuesTableAnnotationComposer
    extends Composer<_$OfflineDatabase, $SyncQueuesTable> {
  $$SyncQueuesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get targetTable => $composableBuilder(
    column: $table.targetTable,
    builder: (column) => column,
  );

  GeneratedColumn<String> get recordId =>
      $composableBuilder(column: $table.recordId, builder: (column) => column);

  GeneratedColumn<String> get operation =>
      $composableBuilder(column: $table.operation, builder: (column) => column);

  GeneratedColumn<String> get data =>
      $composableBuilder(column: $table.data, builder: (column) => column);

  GeneratedColumn<int> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastAttempt => $composableBuilder(
    column: $table.lastAttempt,
    builder: (column) => column,
  );
}

class $$SyncQueuesTableTableManager
    extends
        RootTableManager<
          _$OfflineDatabase,
          $SyncQueuesTable,
          SyncQueue,
          $$SyncQueuesTableFilterComposer,
          $$SyncQueuesTableOrderingComposer,
          $$SyncQueuesTableAnnotationComposer,
          $$SyncQueuesTableCreateCompanionBuilder,
          $$SyncQueuesTableUpdateCompanionBuilder,
          (
            SyncQueue,
            BaseReferences<_$OfflineDatabase, $SyncQueuesTable, SyncQueue>,
          ),
          SyncQueue,
          PrefetchHooks Function()
        > {
  $$SyncQueuesTableTableManager(_$OfflineDatabase db, $SyncQueuesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncQueuesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncQueuesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncQueuesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> targetTable = const Value.absent(),
                Value<String> recordId = const Value.absent(),
                Value<String> operation = const Value.absent(),
                Value<String> data = const Value.absent(),
                Value<int> priority = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> retryCount = const Value.absent(),
                Value<DateTime?> lastAttempt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncQueuesCompanion(
                id: id,
                targetTable: targetTable,
                recordId: recordId,
                operation: operation,
                data: data,
                priority: priority,
                createdAt: createdAt,
                retryCount: retryCount,
                lastAttempt: lastAttempt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String targetTable,
                required String recordId,
                required String operation,
                required String data,
                Value<int> priority = const Value.absent(),
                required DateTime createdAt,
                Value<int> retryCount = const Value.absent(),
                Value<DateTime?> lastAttempt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncQueuesCompanion.insert(
                id: id,
                targetTable: targetTable,
                recordId: recordId,
                operation: operation,
                data: data,
                priority: priority,
                createdAt: createdAt,
                retryCount: retryCount,
                lastAttempt: lastAttempt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncQueuesTableProcessedTableManager =
    ProcessedTableManager<
      _$OfflineDatabase,
      $SyncQueuesTable,
      SyncQueue,
      $$SyncQueuesTableFilterComposer,
      $$SyncQueuesTableOrderingComposer,
      $$SyncQueuesTableAnnotationComposer,
      $$SyncQueuesTableCreateCompanionBuilder,
      $$SyncQueuesTableUpdateCompanionBuilder,
      (
        SyncQueue,
        BaseReferences<_$OfflineDatabase, $SyncQueuesTable, SyncQueue>,
      ),
      SyncQueue,
      PrefetchHooks Function()
    >;
typedef $$MedicalReportsTableCreateCompanionBuilder =
    MedicalReportsCompanion Function({
      required String id,
      required String patientId,
      required String reportType,
      required String title,
      required String hospitalName,
      required String doctorName,
      required String doctorSpecialization,
      required DateTime reportDate,
      required DateTime issuedDate,
      required String summary,
      required String findings,
      required String recommendations,
      required String testResults,
      required String prescriptions,
      Value<String> severity,
      Value<bool> isEmergency,
      Value<String> reportUrl,
      required String attachments,
      required String vitalSigns,
      Value<String> status,
      Value<bool> isSynced,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$MedicalReportsTableUpdateCompanionBuilder =
    MedicalReportsCompanion Function({
      Value<String> id,
      Value<String> patientId,
      Value<String> reportType,
      Value<String> title,
      Value<String> hospitalName,
      Value<String> doctorName,
      Value<String> doctorSpecialization,
      Value<DateTime> reportDate,
      Value<DateTime> issuedDate,
      Value<String> summary,
      Value<String> findings,
      Value<String> recommendations,
      Value<String> testResults,
      Value<String> prescriptions,
      Value<String> severity,
      Value<bool> isEmergency,
      Value<String> reportUrl,
      Value<String> attachments,
      Value<String> vitalSigns,
      Value<String> status,
      Value<bool> isSynced,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$MedicalReportsTableFilterComposer
    extends Composer<_$OfflineDatabase, $MedicalReportsTable> {
  $$MedicalReportsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get patientId => $composableBuilder(
    column: $table.patientId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reportType => $composableBuilder(
    column: $table.reportType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hospitalName => $composableBuilder(
    column: $table.hospitalName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get doctorName => $composableBuilder(
    column: $table.doctorName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get doctorSpecialization => $composableBuilder(
    column: $table.doctorSpecialization,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get reportDate => $composableBuilder(
    column: $table.reportDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get issuedDate => $composableBuilder(
    column: $table.issuedDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get findings => $composableBuilder(
    column: $table.findings,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recommendations => $composableBuilder(
    column: $table.recommendations,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get testResults => $composableBuilder(
    column: $table.testResults,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get prescriptions => $composableBuilder(
    column: $table.prescriptions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get severity => $composableBuilder(
    column: $table.severity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isEmergency => $composableBuilder(
    column: $table.isEmergency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reportUrl => $composableBuilder(
    column: $table.reportUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get attachments => $composableBuilder(
    column: $table.attachments,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get vitalSigns => $composableBuilder(
    column: $table.vitalSigns,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MedicalReportsTableOrderingComposer
    extends Composer<_$OfflineDatabase, $MedicalReportsTable> {
  $$MedicalReportsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get patientId => $composableBuilder(
    column: $table.patientId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reportType => $composableBuilder(
    column: $table.reportType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hospitalName => $composableBuilder(
    column: $table.hospitalName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get doctorName => $composableBuilder(
    column: $table.doctorName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get doctorSpecialization => $composableBuilder(
    column: $table.doctorSpecialization,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get reportDate => $composableBuilder(
    column: $table.reportDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get issuedDate => $composableBuilder(
    column: $table.issuedDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get findings => $composableBuilder(
    column: $table.findings,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recommendations => $composableBuilder(
    column: $table.recommendations,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get testResults => $composableBuilder(
    column: $table.testResults,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get prescriptions => $composableBuilder(
    column: $table.prescriptions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get severity => $composableBuilder(
    column: $table.severity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isEmergency => $composableBuilder(
    column: $table.isEmergency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reportUrl => $composableBuilder(
    column: $table.reportUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get attachments => $composableBuilder(
    column: $table.attachments,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get vitalSigns => $composableBuilder(
    column: $table.vitalSigns,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MedicalReportsTableAnnotationComposer
    extends Composer<_$OfflineDatabase, $MedicalReportsTable> {
  $$MedicalReportsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get patientId =>
      $composableBuilder(column: $table.patientId, builder: (column) => column);

  GeneratedColumn<String> get reportType => $composableBuilder(
    column: $table.reportType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get hospitalName => $composableBuilder(
    column: $table.hospitalName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get doctorName => $composableBuilder(
    column: $table.doctorName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get doctorSpecialization => $composableBuilder(
    column: $table.doctorSpecialization,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get reportDate => $composableBuilder(
    column: $table.reportDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get issuedDate => $composableBuilder(
    column: $table.issuedDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get summary =>
      $composableBuilder(column: $table.summary, builder: (column) => column);

  GeneratedColumn<String> get findings =>
      $composableBuilder(column: $table.findings, builder: (column) => column);

  GeneratedColumn<String> get recommendations => $composableBuilder(
    column: $table.recommendations,
    builder: (column) => column,
  );

  GeneratedColumn<String> get testResults => $composableBuilder(
    column: $table.testResults,
    builder: (column) => column,
  );

  GeneratedColumn<String> get prescriptions => $composableBuilder(
    column: $table.prescriptions,
    builder: (column) => column,
  );

  GeneratedColumn<String> get severity =>
      $composableBuilder(column: $table.severity, builder: (column) => column);

  GeneratedColumn<bool> get isEmergency => $composableBuilder(
    column: $table.isEmergency,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reportUrl =>
      $composableBuilder(column: $table.reportUrl, builder: (column) => column);

  GeneratedColumn<String> get attachments => $composableBuilder(
    column: $table.attachments,
    builder: (column) => column,
  );

  GeneratedColumn<String> get vitalSigns => $composableBuilder(
    column: $table.vitalSigns,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$MedicalReportsTableTableManager
    extends
        RootTableManager<
          _$OfflineDatabase,
          $MedicalReportsTable,
          MedicalReport,
          $$MedicalReportsTableFilterComposer,
          $$MedicalReportsTableOrderingComposer,
          $$MedicalReportsTableAnnotationComposer,
          $$MedicalReportsTableCreateCompanionBuilder,
          $$MedicalReportsTableUpdateCompanionBuilder,
          (
            MedicalReport,
            BaseReferences<
              _$OfflineDatabase,
              $MedicalReportsTable,
              MedicalReport
            >,
          ),
          MedicalReport,
          PrefetchHooks Function()
        > {
  $$MedicalReportsTableTableManager(
    _$OfflineDatabase db,
    $MedicalReportsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MedicalReportsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MedicalReportsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MedicalReportsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> patientId = const Value.absent(),
                Value<String> reportType = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> hospitalName = const Value.absent(),
                Value<String> doctorName = const Value.absent(),
                Value<String> doctorSpecialization = const Value.absent(),
                Value<DateTime> reportDate = const Value.absent(),
                Value<DateTime> issuedDate = const Value.absent(),
                Value<String> summary = const Value.absent(),
                Value<String> findings = const Value.absent(),
                Value<String> recommendations = const Value.absent(),
                Value<String> testResults = const Value.absent(),
                Value<String> prescriptions = const Value.absent(),
                Value<String> severity = const Value.absent(),
                Value<bool> isEmergency = const Value.absent(),
                Value<String> reportUrl = const Value.absent(),
                Value<String> attachments = const Value.absent(),
                Value<String> vitalSigns = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MedicalReportsCompanion(
                id: id,
                patientId: patientId,
                reportType: reportType,
                title: title,
                hospitalName: hospitalName,
                doctorName: doctorName,
                doctorSpecialization: doctorSpecialization,
                reportDate: reportDate,
                issuedDate: issuedDate,
                summary: summary,
                findings: findings,
                recommendations: recommendations,
                testResults: testResults,
                prescriptions: prescriptions,
                severity: severity,
                isEmergency: isEmergency,
                reportUrl: reportUrl,
                attachments: attachments,
                vitalSigns: vitalSigns,
                status: status,
                isSynced: isSynced,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String patientId,
                required String reportType,
                required String title,
                required String hospitalName,
                required String doctorName,
                required String doctorSpecialization,
                required DateTime reportDate,
                required DateTime issuedDate,
                required String summary,
                required String findings,
                required String recommendations,
                required String testResults,
                required String prescriptions,
                Value<String> severity = const Value.absent(),
                Value<bool> isEmergency = const Value.absent(),
                Value<String> reportUrl = const Value.absent(),
                required String attachments,
                required String vitalSigns,
                Value<String> status = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => MedicalReportsCompanion.insert(
                id: id,
                patientId: patientId,
                reportType: reportType,
                title: title,
                hospitalName: hospitalName,
                doctorName: doctorName,
                doctorSpecialization: doctorSpecialization,
                reportDate: reportDate,
                issuedDate: issuedDate,
                summary: summary,
                findings: findings,
                recommendations: recommendations,
                testResults: testResults,
                prescriptions: prescriptions,
                severity: severity,
                isEmergency: isEmergency,
                reportUrl: reportUrl,
                attachments: attachments,
                vitalSigns: vitalSigns,
                status: status,
                isSynced: isSynced,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MedicalReportsTableProcessedTableManager =
    ProcessedTableManager<
      _$OfflineDatabase,
      $MedicalReportsTable,
      MedicalReport,
      $$MedicalReportsTableFilterComposer,
      $$MedicalReportsTableOrderingComposer,
      $$MedicalReportsTableAnnotationComposer,
      $$MedicalReportsTableCreateCompanionBuilder,
      $$MedicalReportsTableUpdateCompanionBuilder,
      (
        MedicalReport,
        BaseReferences<_$OfflineDatabase, $MedicalReportsTable, MedicalReport>,
      ),
      MedicalReport,
      PrefetchHooks Function()
    >;
typedef $$VitalSignsTableCreateCompanionBuilder =
    VitalSignsCompanion Function({
      required String id,
      required String patientId,
      required DateTime recordedDate,
      Value<double?> bloodPressureSystolic,
      Value<double?> bloodPressureDiastolic,
      Value<double?> heartRate,
      Value<double?> temperature,
      Value<double?> respiratoryRate,
      Value<double?> oxygenSaturation,
      Value<double?> bloodSugar,
      Value<double?> weight,
      Value<double?> height,
      Value<double?> bmi,
      Value<String> recordedBy,
      Value<String> notes,
      Value<bool> isSynced,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$VitalSignsTableUpdateCompanionBuilder =
    VitalSignsCompanion Function({
      Value<String> id,
      Value<String> patientId,
      Value<DateTime> recordedDate,
      Value<double?> bloodPressureSystolic,
      Value<double?> bloodPressureDiastolic,
      Value<double?> heartRate,
      Value<double?> temperature,
      Value<double?> respiratoryRate,
      Value<double?> oxygenSaturation,
      Value<double?> bloodSugar,
      Value<double?> weight,
      Value<double?> height,
      Value<double?> bmi,
      Value<String> recordedBy,
      Value<String> notes,
      Value<bool> isSynced,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$VitalSignsTableFilterComposer
    extends Composer<_$OfflineDatabase, $VitalSignsTable> {
  $$VitalSignsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get patientId => $composableBuilder(
    column: $table.patientId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get recordedDate => $composableBuilder(
    column: $table.recordedDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get bloodPressureSystolic => $composableBuilder(
    column: $table.bloodPressureSystolic,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get bloodPressureDiastolic => $composableBuilder(
    column: $table.bloodPressureDiastolic,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get heartRate => $composableBuilder(
    column: $table.heartRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get temperature => $composableBuilder(
    column: $table.temperature,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get respiratoryRate => $composableBuilder(
    column: $table.respiratoryRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get oxygenSaturation => $composableBuilder(
    column: $table.oxygenSaturation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get bloodSugar => $composableBuilder(
    column: $table.bloodSugar,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weight => $composableBuilder(
    column: $table.weight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get height => $composableBuilder(
    column: $table.height,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get bmi => $composableBuilder(
    column: $table.bmi,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recordedBy => $composableBuilder(
    column: $table.recordedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$VitalSignsTableOrderingComposer
    extends Composer<_$OfflineDatabase, $VitalSignsTable> {
  $$VitalSignsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get patientId => $composableBuilder(
    column: $table.patientId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get recordedDate => $composableBuilder(
    column: $table.recordedDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get bloodPressureSystolic => $composableBuilder(
    column: $table.bloodPressureSystolic,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get bloodPressureDiastolic => $composableBuilder(
    column: $table.bloodPressureDiastolic,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get heartRate => $composableBuilder(
    column: $table.heartRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get temperature => $composableBuilder(
    column: $table.temperature,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get respiratoryRate => $composableBuilder(
    column: $table.respiratoryRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get oxygenSaturation => $composableBuilder(
    column: $table.oxygenSaturation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get bloodSugar => $composableBuilder(
    column: $table.bloodSugar,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weight => $composableBuilder(
    column: $table.weight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get height => $composableBuilder(
    column: $table.height,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get bmi => $composableBuilder(
    column: $table.bmi,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recordedBy => $composableBuilder(
    column: $table.recordedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$VitalSignsTableAnnotationComposer
    extends Composer<_$OfflineDatabase, $VitalSignsTable> {
  $$VitalSignsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get patientId =>
      $composableBuilder(column: $table.patientId, builder: (column) => column);

  GeneratedColumn<DateTime> get recordedDate => $composableBuilder(
    column: $table.recordedDate,
    builder: (column) => column,
  );

  GeneratedColumn<double> get bloodPressureSystolic => $composableBuilder(
    column: $table.bloodPressureSystolic,
    builder: (column) => column,
  );

  GeneratedColumn<double> get bloodPressureDiastolic => $composableBuilder(
    column: $table.bloodPressureDiastolic,
    builder: (column) => column,
  );

  GeneratedColumn<double> get heartRate =>
      $composableBuilder(column: $table.heartRate, builder: (column) => column);

  GeneratedColumn<double> get temperature => $composableBuilder(
    column: $table.temperature,
    builder: (column) => column,
  );

  GeneratedColumn<double> get respiratoryRate => $composableBuilder(
    column: $table.respiratoryRate,
    builder: (column) => column,
  );

  GeneratedColumn<double> get oxygenSaturation => $composableBuilder(
    column: $table.oxygenSaturation,
    builder: (column) => column,
  );

  GeneratedColumn<double> get bloodSugar => $composableBuilder(
    column: $table.bloodSugar,
    builder: (column) => column,
  );

  GeneratedColumn<double> get weight =>
      $composableBuilder(column: $table.weight, builder: (column) => column);

  GeneratedColumn<double> get height =>
      $composableBuilder(column: $table.height, builder: (column) => column);

  GeneratedColumn<double> get bmi =>
      $composableBuilder(column: $table.bmi, builder: (column) => column);

  GeneratedColumn<String> get recordedBy => $composableBuilder(
    column: $table.recordedBy,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$VitalSignsTableTableManager
    extends
        RootTableManager<
          _$OfflineDatabase,
          $VitalSignsTable,
          VitalSign,
          $$VitalSignsTableFilterComposer,
          $$VitalSignsTableOrderingComposer,
          $$VitalSignsTableAnnotationComposer,
          $$VitalSignsTableCreateCompanionBuilder,
          $$VitalSignsTableUpdateCompanionBuilder,
          (
            VitalSign,
            BaseReferences<_$OfflineDatabase, $VitalSignsTable, VitalSign>,
          ),
          VitalSign,
          PrefetchHooks Function()
        > {
  $$VitalSignsTableTableManager(_$OfflineDatabase db, $VitalSignsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VitalSignsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VitalSignsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VitalSignsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> patientId = const Value.absent(),
                Value<DateTime> recordedDate = const Value.absent(),
                Value<double?> bloodPressureSystolic = const Value.absent(),
                Value<double?> bloodPressureDiastolic = const Value.absent(),
                Value<double?> heartRate = const Value.absent(),
                Value<double?> temperature = const Value.absent(),
                Value<double?> respiratoryRate = const Value.absent(),
                Value<double?> oxygenSaturation = const Value.absent(),
                Value<double?> bloodSugar = const Value.absent(),
                Value<double?> weight = const Value.absent(),
                Value<double?> height = const Value.absent(),
                Value<double?> bmi = const Value.absent(),
                Value<String> recordedBy = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VitalSignsCompanion(
                id: id,
                patientId: patientId,
                recordedDate: recordedDate,
                bloodPressureSystolic: bloodPressureSystolic,
                bloodPressureDiastolic: bloodPressureDiastolic,
                heartRate: heartRate,
                temperature: temperature,
                respiratoryRate: respiratoryRate,
                oxygenSaturation: oxygenSaturation,
                bloodSugar: bloodSugar,
                weight: weight,
                height: height,
                bmi: bmi,
                recordedBy: recordedBy,
                notes: notes,
                isSynced: isSynced,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String patientId,
                required DateTime recordedDate,
                Value<double?> bloodPressureSystolic = const Value.absent(),
                Value<double?> bloodPressureDiastolic = const Value.absent(),
                Value<double?> heartRate = const Value.absent(),
                Value<double?> temperature = const Value.absent(),
                Value<double?> respiratoryRate = const Value.absent(),
                Value<double?> oxygenSaturation = const Value.absent(),
                Value<double?> bloodSugar = const Value.absent(),
                Value<double?> weight = const Value.absent(),
                Value<double?> height = const Value.absent(),
                Value<double?> bmi = const Value.absent(),
                Value<String> recordedBy = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => VitalSignsCompanion.insert(
                id: id,
                patientId: patientId,
                recordedDate: recordedDate,
                bloodPressureSystolic: bloodPressureSystolic,
                bloodPressureDiastolic: bloodPressureDiastolic,
                heartRate: heartRate,
                temperature: temperature,
                respiratoryRate: respiratoryRate,
                oxygenSaturation: oxygenSaturation,
                bloodSugar: bloodSugar,
                weight: weight,
                height: height,
                bmi: bmi,
                recordedBy: recordedBy,
                notes: notes,
                isSynced: isSynced,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$VitalSignsTableProcessedTableManager =
    ProcessedTableManager<
      _$OfflineDatabase,
      $VitalSignsTable,
      VitalSign,
      $$VitalSignsTableFilterComposer,
      $$VitalSignsTableOrderingComposer,
      $$VitalSignsTableAnnotationComposer,
      $$VitalSignsTableCreateCompanionBuilder,
      $$VitalSignsTableUpdateCompanionBuilder,
      (
        VitalSign,
        BaseReferences<_$OfflineDatabase, $VitalSignsTable, VitalSign>,
      ),
      VitalSign,
      PrefetchHooks Function()
    >;
typedef $$FamilyMembersTableCreateCompanionBuilder =
    FamilyMembersCompanion Function({
      required String id,
      required String familyGroupId,
      required String primaryUserId,
      required String name,
      required String relationship,
      required DateTime dateOfBirth,
      required String gender,
      Value<String?> bloodGroup,
      Value<String?> phoneNumber,
      Value<String?> email,
      Value<String?> allergies,
      Value<String?> medicalConditions,
      Value<String?> medications,
      Value<String?> emergencyContact,
      Value<bool> isActive,
      Value<bool> hasOwnAccount,
      Value<String?> linkedAccountId,
      Value<bool> allowIndependentAccess,
      Value<String?> caregiverPermissions,
      Value<String?> profileImageUrl,
      Value<bool> isSynced,
      required DateTime createdAt,
      required DateTime lastModified,
      Value<int> rowid,
    });
typedef $$FamilyMembersTableUpdateCompanionBuilder =
    FamilyMembersCompanion Function({
      Value<String> id,
      Value<String> familyGroupId,
      Value<String> primaryUserId,
      Value<String> name,
      Value<String> relationship,
      Value<DateTime> dateOfBirth,
      Value<String> gender,
      Value<String?> bloodGroup,
      Value<String?> phoneNumber,
      Value<String?> email,
      Value<String?> allergies,
      Value<String?> medicalConditions,
      Value<String?> medications,
      Value<String?> emergencyContact,
      Value<bool> isActive,
      Value<bool> hasOwnAccount,
      Value<String?> linkedAccountId,
      Value<bool> allowIndependentAccess,
      Value<String?> caregiverPermissions,
      Value<String?> profileImageUrl,
      Value<bool> isSynced,
      Value<DateTime> createdAt,
      Value<DateTime> lastModified,
      Value<int> rowid,
    });

class $$FamilyMembersTableFilterComposer
    extends Composer<_$OfflineDatabase, $FamilyMembersTable> {
  $$FamilyMembersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get familyGroupId => $composableBuilder(
    column: $table.familyGroupId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get primaryUserId => $composableBuilder(
    column: $table.primaryUserId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get relationship => $composableBuilder(
    column: $table.relationship,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dateOfBirth => $composableBuilder(
    column: $table.dateOfBirth,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bloodGroup => $composableBuilder(
    column: $table.bloodGroup,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get allergies => $composableBuilder(
    column: $table.allergies,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get medicalConditions => $composableBuilder(
    column: $table.medicalConditions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get medications => $composableBuilder(
    column: $table.medications,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get emergencyContact => $composableBuilder(
    column: $table.emergencyContact,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hasOwnAccount => $composableBuilder(
    column: $table.hasOwnAccount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get linkedAccountId => $composableBuilder(
    column: $table.linkedAccountId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get allowIndependentAccess => $composableBuilder(
    column: $table.allowIndependentAccess,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get caregiverPermissions => $composableBuilder(
    column: $table.caregiverPermissions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get profileImageUrl => $composableBuilder(
    column: $table.profileImageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastModified => $composableBuilder(
    column: $table.lastModified,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FamilyMembersTableOrderingComposer
    extends Composer<_$OfflineDatabase, $FamilyMembersTable> {
  $$FamilyMembersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get familyGroupId => $composableBuilder(
    column: $table.familyGroupId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get primaryUserId => $composableBuilder(
    column: $table.primaryUserId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get relationship => $composableBuilder(
    column: $table.relationship,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dateOfBirth => $composableBuilder(
    column: $table.dateOfBirth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bloodGroup => $composableBuilder(
    column: $table.bloodGroup,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get allergies => $composableBuilder(
    column: $table.allergies,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get medicalConditions => $composableBuilder(
    column: $table.medicalConditions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get medications => $composableBuilder(
    column: $table.medications,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get emergencyContact => $composableBuilder(
    column: $table.emergencyContact,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hasOwnAccount => $composableBuilder(
    column: $table.hasOwnAccount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get linkedAccountId => $composableBuilder(
    column: $table.linkedAccountId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get allowIndependentAccess => $composableBuilder(
    column: $table.allowIndependentAccess,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get caregiverPermissions => $composableBuilder(
    column: $table.caregiverPermissions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get profileImageUrl => $composableBuilder(
    column: $table.profileImageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastModified => $composableBuilder(
    column: $table.lastModified,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FamilyMembersTableAnnotationComposer
    extends Composer<_$OfflineDatabase, $FamilyMembersTable> {
  $$FamilyMembersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get familyGroupId => $composableBuilder(
    column: $table.familyGroupId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get primaryUserId => $composableBuilder(
    column: $table.primaryUserId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get relationship => $composableBuilder(
    column: $table.relationship,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dateOfBirth => $composableBuilder(
    column: $table.dateOfBirth,
    builder: (column) => column,
  );

  GeneratedColumn<String> get gender =>
      $composableBuilder(column: $table.gender, builder: (column) => column);

  GeneratedColumn<String> get bloodGroup => $composableBuilder(
    column: $table.bloodGroup,
    builder: (column) => column,
  );

  GeneratedColumn<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get allergies =>
      $composableBuilder(column: $table.allergies, builder: (column) => column);

  GeneratedColumn<String> get medicalConditions => $composableBuilder(
    column: $table.medicalConditions,
    builder: (column) => column,
  );

  GeneratedColumn<String> get medications => $composableBuilder(
    column: $table.medications,
    builder: (column) => column,
  );

  GeneratedColumn<String> get emergencyContact => $composableBuilder(
    column: $table.emergencyContact,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<bool> get hasOwnAccount => $composableBuilder(
    column: $table.hasOwnAccount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get linkedAccountId => $composableBuilder(
    column: $table.linkedAccountId,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get allowIndependentAccess => $composableBuilder(
    column: $table.allowIndependentAccess,
    builder: (column) => column,
  );

  GeneratedColumn<String> get caregiverPermissions => $composableBuilder(
    column: $table.caregiverPermissions,
    builder: (column) => column,
  );

  GeneratedColumn<String> get profileImageUrl => $composableBuilder(
    column: $table.profileImageUrl,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastModified => $composableBuilder(
    column: $table.lastModified,
    builder: (column) => column,
  );
}

class $$FamilyMembersTableTableManager
    extends
        RootTableManager<
          _$OfflineDatabase,
          $FamilyMembersTable,
          FamilyMember,
          $$FamilyMembersTableFilterComposer,
          $$FamilyMembersTableOrderingComposer,
          $$FamilyMembersTableAnnotationComposer,
          $$FamilyMembersTableCreateCompanionBuilder,
          $$FamilyMembersTableUpdateCompanionBuilder,
          (
            FamilyMember,
            BaseReferences<
              _$OfflineDatabase,
              $FamilyMembersTable,
              FamilyMember
            >,
          ),
          FamilyMember,
          PrefetchHooks Function()
        > {
  $$FamilyMembersTableTableManager(
    _$OfflineDatabase db,
    $FamilyMembersTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FamilyMembersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FamilyMembersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FamilyMembersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> familyGroupId = const Value.absent(),
                Value<String> primaryUserId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> relationship = const Value.absent(),
                Value<DateTime> dateOfBirth = const Value.absent(),
                Value<String> gender = const Value.absent(),
                Value<String?> bloodGroup = const Value.absent(),
                Value<String?> phoneNumber = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> allergies = const Value.absent(),
                Value<String?> medicalConditions = const Value.absent(),
                Value<String?> medications = const Value.absent(),
                Value<String?> emergencyContact = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<bool> hasOwnAccount = const Value.absent(),
                Value<String?> linkedAccountId = const Value.absent(),
                Value<bool> allowIndependentAccess = const Value.absent(),
                Value<String?> caregiverPermissions = const Value.absent(),
                Value<String?> profileImageUrl = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> lastModified = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FamilyMembersCompanion(
                id: id,
                familyGroupId: familyGroupId,
                primaryUserId: primaryUserId,
                name: name,
                relationship: relationship,
                dateOfBirth: dateOfBirth,
                gender: gender,
                bloodGroup: bloodGroup,
                phoneNumber: phoneNumber,
                email: email,
                allergies: allergies,
                medicalConditions: medicalConditions,
                medications: medications,
                emergencyContact: emergencyContact,
                isActive: isActive,
                hasOwnAccount: hasOwnAccount,
                linkedAccountId: linkedAccountId,
                allowIndependentAccess: allowIndependentAccess,
                caregiverPermissions: caregiverPermissions,
                profileImageUrl: profileImageUrl,
                isSynced: isSynced,
                createdAt: createdAt,
                lastModified: lastModified,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String familyGroupId,
                required String primaryUserId,
                required String name,
                required String relationship,
                required DateTime dateOfBirth,
                required String gender,
                Value<String?> bloodGroup = const Value.absent(),
                Value<String?> phoneNumber = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> allergies = const Value.absent(),
                Value<String?> medicalConditions = const Value.absent(),
                Value<String?> medications = const Value.absent(),
                Value<String?> emergencyContact = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<bool> hasOwnAccount = const Value.absent(),
                Value<String?> linkedAccountId = const Value.absent(),
                Value<bool> allowIndependentAccess = const Value.absent(),
                Value<String?> caregiverPermissions = const Value.absent(),
                Value<String?> profileImageUrl = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                required DateTime createdAt,
                required DateTime lastModified,
                Value<int> rowid = const Value.absent(),
              }) => FamilyMembersCompanion.insert(
                id: id,
                familyGroupId: familyGroupId,
                primaryUserId: primaryUserId,
                name: name,
                relationship: relationship,
                dateOfBirth: dateOfBirth,
                gender: gender,
                bloodGroup: bloodGroup,
                phoneNumber: phoneNumber,
                email: email,
                allergies: allergies,
                medicalConditions: medicalConditions,
                medications: medications,
                emergencyContact: emergencyContact,
                isActive: isActive,
                hasOwnAccount: hasOwnAccount,
                linkedAccountId: linkedAccountId,
                allowIndependentAccess: allowIndependentAccess,
                caregiverPermissions: caregiverPermissions,
                profileImageUrl: profileImageUrl,
                isSynced: isSynced,
                createdAt: createdAt,
                lastModified: lastModified,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FamilyMembersTableProcessedTableManager =
    ProcessedTableManager<
      _$OfflineDatabase,
      $FamilyMembersTable,
      FamilyMember,
      $$FamilyMembersTableFilterComposer,
      $$FamilyMembersTableOrderingComposer,
      $$FamilyMembersTableAnnotationComposer,
      $$FamilyMembersTableCreateCompanionBuilder,
      $$FamilyMembersTableUpdateCompanionBuilder,
      (
        FamilyMember,
        BaseReferences<_$OfflineDatabase, $FamilyMembersTable, FamilyMember>,
      ),
      FamilyMember,
      PrefetchHooks Function()
    >;
typedef $$FamilyGroupsTableCreateCompanionBuilder =
    FamilyGroupsCompanion Function({
      required String id,
      required String primaryMemberId,
      required String familyName,
      Value<String?> address,
      Value<String?> village,
      Value<String?> pincode,
      Value<String?> emergencyContact,
      Value<String?> emergencyPhone,
      Value<String?> healthInsurance,
      Value<bool> isActive,
      Value<bool> isSynced,
      required DateTime createdAt,
      required DateTime lastModified,
      Value<int> rowid,
    });
typedef $$FamilyGroupsTableUpdateCompanionBuilder =
    FamilyGroupsCompanion Function({
      Value<String> id,
      Value<String> primaryMemberId,
      Value<String> familyName,
      Value<String?> address,
      Value<String?> village,
      Value<String?> pincode,
      Value<String?> emergencyContact,
      Value<String?> emergencyPhone,
      Value<String?> healthInsurance,
      Value<bool> isActive,
      Value<bool> isSynced,
      Value<DateTime> createdAt,
      Value<DateTime> lastModified,
      Value<int> rowid,
    });

class $$FamilyGroupsTableFilterComposer
    extends Composer<_$OfflineDatabase, $FamilyGroupsTable> {
  $$FamilyGroupsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get primaryMemberId => $composableBuilder(
    column: $table.primaryMemberId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get familyName => $composableBuilder(
    column: $table.familyName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get village => $composableBuilder(
    column: $table.village,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pincode => $composableBuilder(
    column: $table.pincode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get emergencyContact => $composableBuilder(
    column: $table.emergencyContact,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get emergencyPhone => $composableBuilder(
    column: $table.emergencyPhone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get healthInsurance => $composableBuilder(
    column: $table.healthInsurance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastModified => $composableBuilder(
    column: $table.lastModified,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FamilyGroupsTableOrderingComposer
    extends Composer<_$OfflineDatabase, $FamilyGroupsTable> {
  $$FamilyGroupsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get primaryMemberId => $composableBuilder(
    column: $table.primaryMemberId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get familyName => $composableBuilder(
    column: $table.familyName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get village => $composableBuilder(
    column: $table.village,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pincode => $composableBuilder(
    column: $table.pincode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get emergencyContact => $composableBuilder(
    column: $table.emergencyContact,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get emergencyPhone => $composableBuilder(
    column: $table.emergencyPhone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get healthInsurance => $composableBuilder(
    column: $table.healthInsurance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastModified => $composableBuilder(
    column: $table.lastModified,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FamilyGroupsTableAnnotationComposer
    extends Composer<_$OfflineDatabase, $FamilyGroupsTable> {
  $$FamilyGroupsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get primaryMemberId => $composableBuilder(
    column: $table.primaryMemberId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get familyName => $composableBuilder(
    column: $table.familyName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get village =>
      $composableBuilder(column: $table.village, builder: (column) => column);

  GeneratedColumn<String> get pincode =>
      $composableBuilder(column: $table.pincode, builder: (column) => column);

  GeneratedColumn<String> get emergencyContact => $composableBuilder(
    column: $table.emergencyContact,
    builder: (column) => column,
  );

  GeneratedColumn<String> get emergencyPhone => $composableBuilder(
    column: $table.emergencyPhone,
    builder: (column) => column,
  );

  GeneratedColumn<String> get healthInsurance => $composableBuilder(
    column: $table.healthInsurance,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastModified => $composableBuilder(
    column: $table.lastModified,
    builder: (column) => column,
  );
}

class $$FamilyGroupsTableTableManager
    extends
        RootTableManager<
          _$OfflineDatabase,
          $FamilyGroupsTable,
          FamilyGroup,
          $$FamilyGroupsTableFilterComposer,
          $$FamilyGroupsTableOrderingComposer,
          $$FamilyGroupsTableAnnotationComposer,
          $$FamilyGroupsTableCreateCompanionBuilder,
          $$FamilyGroupsTableUpdateCompanionBuilder,
          (
            FamilyGroup,
            BaseReferences<_$OfflineDatabase, $FamilyGroupsTable, FamilyGroup>,
          ),
          FamilyGroup,
          PrefetchHooks Function()
        > {
  $$FamilyGroupsTableTableManager(
    _$OfflineDatabase db,
    $FamilyGroupsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FamilyGroupsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FamilyGroupsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FamilyGroupsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> primaryMemberId = const Value.absent(),
                Value<String> familyName = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<String?> village = const Value.absent(),
                Value<String?> pincode = const Value.absent(),
                Value<String?> emergencyContact = const Value.absent(),
                Value<String?> emergencyPhone = const Value.absent(),
                Value<String?> healthInsurance = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> lastModified = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FamilyGroupsCompanion(
                id: id,
                primaryMemberId: primaryMemberId,
                familyName: familyName,
                address: address,
                village: village,
                pincode: pincode,
                emergencyContact: emergencyContact,
                emergencyPhone: emergencyPhone,
                healthInsurance: healthInsurance,
                isActive: isActive,
                isSynced: isSynced,
                createdAt: createdAt,
                lastModified: lastModified,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String primaryMemberId,
                required String familyName,
                Value<String?> address = const Value.absent(),
                Value<String?> village = const Value.absent(),
                Value<String?> pincode = const Value.absent(),
                Value<String?> emergencyContact = const Value.absent(),
                Value<String?> emergencyPhone = const Value.absent(),
                Value<String?> healthInsurance = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                required DateTime createdAt,
                required DateTime lastModified,
                Value<int> rowid = const Value.absent(),
              }) => FamilyGroupsCompanion.insert(
                id: id,
                primaryMemberId: primaryMemberId,
                familyName: familyName,
                address: address,
                village: village,
                pincode: pincode,
                emergencyContact: emergencyContact,
                emergencyPhone: emergencyPhone,
                healthInsurance: healthInsurance,
                isActive: isActive,
                isSynced: isSynced,
                createdAt: createdAt,
                lastModified: lastModified,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FamilyGroupsTableProcessedTableManager =
    ProcessedTableManager<
      _$OfflineDatabase,
      $FamilyGroupsTable,
      FamilyGroup,
      $$FamilyGroupsTableFilterComposer,
      $$FamilyGroupsTableOrderingComposer,
      $$FamilyGroupsTableAnnotationComposer,
      $$FamilyGroupsTableCreateCompanionBuilder,
      $$FamilyGroupsTableUpdateCompanionBuilder,
      (
        FamilyGroup,
        BaseReferences<_$OfflineDatabase, $FamilyGroupsTable, FamilyGroup>,
      ),
      FamilyGroup,
      PrefetchHooks Function()
    >;
typedef $$FamilyHealthRecordsTableCreateCompanionBuilder =
    FamilyHealthRecordsCompanion Function({
      required String id,
      required String familyMemberId,
      required String familyGroupId,
      required String recordType,
      required String title,
      Value<String?> description,
      Value<String?> condition,
      Value<String?> symptoms,
      Value<String> severity,
      Value<String?> treatment,
      Value<String?> medications,
      Value<String?> doctorName,
      Value<String?> hospitalName,
      Value<String?> reportUrl,
      Value<String?> attachments,
      required DateTime recordDate,
      Value<DateTime?> followUpDate,
      Value<bool> isEmergency,
      Value<bool> isResolved,
      Value<String?> notes,
      Value<bool> isSynced,
      required DateTime createdAt,
      required DateTime lastModified,
      Value<int> rowid,
    });
typedef $$FamilyHealthRecordsTableUpdateCompanionBuilder =
    FamilyHealthRecordsCompanion Function({
      Value<String> id,
      Value<String> familyMemberId,
      Value<String> familyGroupId,
      Value<String> recordType,
      Value<String> title,
      Value<String?> description,
      Value<String?> condition,
      Value<String?> symptoms,
      Value<String> severity,
      Value<String?> treatment,
      Value<String?> medications,
      Value<String?> doctorName,
      Value<String?> hospitalName,
      Value<String?> reportUrl,
      Value<String?> attachments,
      Value<DateTime> recordDate,
      Value<DateTime?> followUpDate,
      Value<bool> isEmergency,
      Value<bool> isResolved,
      Value<String?> notes,
      Value<bool> isSynced,
      Value<DateTime> createdAt,
      Value<DateTime> lastModified,
      Value<int> rowid,
    });

class $$FamilyHealthRecordsTableFilterComposer
    extends Composer<_$OfflineDatabase, $FamilyHealthRecordsTable> {
  $$FamilyHealthRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get familyMemberId => $composableBuilder(
    column: $table.familyMemberId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get familyGroupId => $composableBuilder(
    column: $table.familyGroupId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recordType => $composableBuilder(
    column: $table.recordType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get condition => $composableBuilder(
    column: $table.condition,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get symptoms => $composableBuilder(
    column: $table.symptoms,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get severity => $composableBuilder(
    column: $table.severity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get treatment => $composableBuilder(
    column: $table.treatment,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get medications => $composableBuilder(
    column: $table.medications,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get doctorName => $composableBuilder(
    column: $table.doctorName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hospitalName => $composableBuilder(
    column: $table.hospitalName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reportUrl => $composableBuilder(
    column: $table.reportUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get attachments => $composableBuilder(
    column: $table.attachments,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get recordDate => $composableBuilder(
    column: $table.recordDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get followUpDate => $composableBuilder(
    column: $table.followUpDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isEmergency => $composableBuilder(
    column: $table.isEmergency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isResolved => $composableBuilder(
    column: $table.isResolved,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastModified => $composableBuilder(
    column: $table.lastModified,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FamilyHealthRecordsTableOrderingComposer
    extends Composer<_$OfflineDatabase, $FamilyHealthRecordsTable> {
  $$FamilyHealthRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get familyMemberId => $composableBuilder(
    column: $table.familyMemberId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get familyGroupId => $composableBuilder(
    column: $table.familyGroupId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recordType => $composableBuilder(
    column: $table.recordType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get condition => $composableBuilder(
    column: $table.condition,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get symptoms => $composableBuilder(
    column: $table.symptoms,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get severity => $composableBuilder(
    column: $table.severity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get treatment => $composableBuilder(
    column: $table.treatment,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get medications => $composableBuilder(
    column: $table.medications,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get doctorName => $composableBuilder(
    column: $table.doctorName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hospitalName => $composableBuilder(
    column: $table.hospitalName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reportUrl => $composableBuilder(
    column: $table.reportUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get attachments => $composableBuilder(
    column: $table.attachments,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get recordDate => $composableBuilder(
    column: $table.recordDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get followUpDate => $composableBuilder(
    column: $table.followUpDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isEmergency => $composableBuilder(
    column: $table.isEmergency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isResolved => $composableBuilder(
    column: $table.isResolved,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastModified => $composableBuilder(
    column: $table.lastModified,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FamilyHealthRecordsTableAnnotationComposer
    extends Composer<_$OfflineDatabase, $FamilyHealthRecordsTable> {
  $$FamilyHealthRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get familyMemberId => $composableBuilder(
    column: $table.familyMemberId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get familyGroupId => $composableBuilder(
    column: $table.familyGroupId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get recordType => $composableBuilder(
    column: $table.recordType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get condition =>
      $composableBuilder(column: $table.condition, builder: (column) => column);

  GeneratedColumn<String> get symptoms =>
      $composableBuilder(column: $table.symptoms, builder: (column) => column);

  GeneratedColumn<String> get severity =>
      $composableBuilder(column: $table.severity, builder: (column) => column);

  GeneratedColumn<String> get treatment =>
      $composableBuilder(column: $table.treatment, builder: (column) => column);

  GeneratedColumn<String> get medications => $composableBuilder(
    column: $table.medications,
    builder: (column) => column,
  );

  GeneratedColumn<String> get doctorName => $composableBuilder(
    column: $table.doctorName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get hospitalName => $composableBuilder(
    column: $table.hospitalName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reportUrl =>
      $composableBuilder(column: $table.reportUrl, builder: (column) => column);

  GeneratedColumn<String> get attachments => $composableBuilder(
    column: $table.attachments,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get recordDate => $composableBuilder(
    column: $table.recordDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get followUpDate => $composableBuilder(
    column: $table.followUpDate,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isEmergency => $composableBuilder(
    column: $table.isEmergency,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isResolved => $composableBuilder(
    column: $table.isResolved,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastModified => $composableBuilder(
    column: $table.lastModified,
    builder: (column) => column,
  );
}

class $$FamilyHealthRecordsTableTableManager
    extends
        RootTableManager<
          _$OfflineDatabase,
          $FamilyHealthRecordsTable,
          FamilyHealthRecord,
          $$FamilyHealthRecordsTableFilterComposer,
          $$FamilyHealthRecordsTableOrderingComposer,
          $$FamilyHealthRecordsTableAnnotationComposer,
          $$FamilyHealthRecordsTableCreateCompanionBuilder,
          $$FamilyHealthRecordsTableUpdateCompanionBuilder,
          (
            FamilyHealthRecord,
            BaseReferences<
              _$OfflineDatabase,
              $FamilyHealthRecordsTable,
              FamilyHealthRecord
            >,
          ),
          FamilyHealthRecord,
          PrefetchHooks Function()
        > {
  $$FamilyHealthRecordsTableTableManager(
    _$OfflineDatabase db,
    $FamilyHealthRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FamilyHealthRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FamilyHealthRecordsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$FamilyHealthRecordsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> familyMemberId = const Value.absent(),
                Value<String> familyGroupId = const Value.absent(),
                Value<String> recordType = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> condition = const Value.absent(),
                Value<String?> symptoms = const Value.absent(),
                Value<String> severity = const Value.absent(),
                Value<String?> treatment = const Value.absent(),
                Value<String?> medications = const Value.absent(),
                Value<String?> doctorName = const Value.absent(),
                Value<String?> hospitalName = const Value.absent(),
                Value<String?> reportUrl = const Value.absent(),
                Value<String?> attachments = const Value.absent(),
                Value<DateTime> recordDate = const Value.absent(),
                Value<DateTime?> followUpDate = const Value.absent(),
                Value<bool> isEmergency = const Value.absent(),
                Value<bool> isResolved = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> lastModified = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FamilyHealthRecordsCompanion(
                id: id,
                familyMemberId: familyMemberId,
                familyGroupId: familyGroupId,
                recordType: recordType,
                title: title,
                description: description,
                condition: condition,
                symptoms: symptoms,
                severity: severity,
                treatment: treatment,
                medications: medications,
                doctorName: doctorName,
                hospitalName: hospitalName,
                reportUrl: reportUrl,
                attachments: attachments,
                recordDate: recordDate,
                followUpDate: followUpDate,
                isEmergency: isEmergency,
                isResolved: isResolved,
                notes: notes,
                isSynced: isSynced,
                createdAt: createdAt,
                lastModified: lastModified,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String familyMemberId,
                required String familyGroupId,
                required String recordType,
                required String title,
                Value<String?> description = const Value.absent(),
                Value<String?> condition = const Value.absent(),
                Value<String?> symptoms = const Value.absent(),
                Value<String> severity = const Value.absent(),
                Value<String?> treatment = const Value.absent(),
                Value<String?> medications = const Value.absent(),
                Value<String?> doctorName = const Value.absent(),
                Value<String?> hospitalName = const Value.absent(),
                Value<String?> reportUrl = const Value.absent(),
                Value<String?> attachments = const Value.absent(),
                required DateTime recordDate,
                Value<DateTime?> followUpDate = const Value.absent(),
                Value<bool> isEmergency = const Value.absent(),
                Value<bool> isResolved = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                required DateTime createdAt,
                required DateTime lastModified,
                Value<int> rowid = const Value.absent(),
              }) => FamilyHealthRecordsCompanion.insert(
                id: id,
                familyMemberId: familyMemberId,
                familyGroupId: familyGroupId,
                recordType: recordType,
                title: title,
                description: description,
                condition: condition,
                symptoms: symptoms,
                severity: severity,
                treatment: treatment,
                medications: medications,
                doctorName: doctorName,
                hospitalName: hospitalName,
                reportUrl: reportUrl,
                attachments: attachments,
                recordDate: recordDate,
                followUpDate: followUpDate,
                isEmergency: isEmergency,
                isResolved: isResolved,
                notes: notes,
                isSynced: isSynced,
                createdAt: createdAt,
                lastModified: lastModified,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FamilyHealthRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$OfflineDatabase,
      $FamilyHealthRecordsTable,
      FamilyHealthRecord,
      $$FamilyHealthRecordsTableFilterComposer,
      $$FamilyHealthRecordsTableOrderingComposer,
      $$FamilyHealthRecordsTableAnnotationComposer,
      $$FamilyHealthRecordsTableCreateCompanionBuilder,
      $$FamilyHealthRecordsTableUpdateCompanionBuilder,
      (
        FamilyHealthRecord,
        BaseReferences<
          _$OfflineDatabase,
          $FamilyHealthRecordsTable,
          FamilyHealthRecord
        >,
      ),
      FamilyHealthRecord,
      PrefetchHooks Function()
    >;
typedef $$CaregiverSessionsTableCreateCompanionBuilder =
    CaregiverSessionsCompanion Function({
      required String id,
      required String caregiverId,
      required String dependentId,
      required DateTime startTime,
      Value<DateTime?> endTime,
      Value<String?> activatedFeatures,
      Value<String?> actionsPerformed,
      Value<bool> isActive,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$CaregiverSessionsTableUpdateCompanionBuilder =
    CaregiverSessionsCompanion Function({
      Value<String> id,
      Value<String> caregiverId,
      Value<String> dependentId,
      Value<DateTime> startTime,
      Value<DateTime?> endTime,
      Value<String?> activatedFeatures,
      Value<String?> actionsPerformed,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$CaregiverSessionsTableFilterComposer
    extends Composer<_$OfflineDatabase, $CaregiverSessionsTable> {
  $$CaregiverSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get caregiverId => $composableBuilder(
    column: $table.caregiverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dependentId => $composableBuilder(
    column: $table.dependentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get activatedFeatures => $composableBuilder(
    column: $table.activatedFeatures,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get actionsPerformed => $composableBuilder(
    column: $table.actionsPerformed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CaregiverSessionsTableOrderingComposer
    extends Composer<_$OfflineDatabase, $CaregiverSessionsTable> {
  $$CaregiverSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get caregiverId => $composableBuilder(
    column: $table.caregiverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dependentId => $composableBuilder(
    column: $table.dependentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get activatedFeatures => $composableBuilder(
    column: $table.activatedFeatures,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get actionsPerformed => $composableBuilder(
    column: $table.actionsPerformed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CaregiverSessionsTableAnnotationComposer
    extends Composer<_$OfflineDatabase, $CaregiverSessionsTable> {
  $$CaregiverSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get caregiverId => $composableBuilder(
    column: $table.caregiverId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get dependentId => $composableBuilder(
    column: $table.dependentId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startTime =>
      $composableBuilder(column: $table.startTime, builder: (column) => column);

  GeneratedColumn<DateTime> get endTime =>
      $composableBuilder(column: $table.endTime, builder: (column) => column);

  GeneratedColumn<String> get activatedFeatures => $composableBuilder(
    column: $table.activatedFeatures,
    builder: (column) => column,
  );

  GeneratedColumn<String> get actionsPerformed => $composableBuilder(
    column: $table.actionsPerformed,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$CaregiverSessionsTableTableManager
    extends
        RootTableManager<
          _$OfflineDatabase,
          $CaregiverSessionsTable,
          CaregiverSession,
          $$CaregiverSessionsTableFilterComposer,
          $$CaregiverSessionsTableOrderingComposer,
          $$CaregiverSessionsTableAnnotationComposer,
          $$CaregiverSessionsTableCreateCompanionBuilder,
          $$CaregiverSessionsTableUpdateCompanionBuilder,
          (
            CaregiverSession,
            BaseReferences<
              _$OfflineDatabase,
              $CaregiverSessionsTable,
              CaregiverSession
            >,
          ),
          CaregiverSession,
          PrefetchHooks Function()
        > {
  $$CaregiverSessionsTableTableManager(
    _$OfflineDatabase db,
    $CaregiverSessionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CaregiverSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CaregiverSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CaregiverSessionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> caregiverId = const Value.absent(),
                Value<String> dependentId = const Value.absent(),
                Value<DateTime> startTime = const Value.absent(),
                Value<DateTime?> endTime = const Value.absent(),
                Value<String?> activatedFeatures = const Value.absent(),
                Value<String?> actionsPerformed = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CaregiverSessionsCompanion(
                id: id,
                caregiverId: caregiverId,
                dependentId: dependentId,
                startTime: startTime,
                endTime: endTime,
                activatedFeatures: activatedFeatures,
                actionsPerformed: actionsPerformed,
                isActive: isActive,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String caregiverId,
                required String dependentId,
                required DateTime startTime,
                Value<DateTime?> endTime = const Value.absent(),
                Value<String?> activatedFeatures = const Value.absent(),
                Value<String?> actionsPerformed = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => CaregiverSessionsCompanion.insert(
                id: id,
                caregiverId: caregiverId,
                dependentId: dependentId,
                startTime: startTime,
                endTime: endTime,
                activatedFeatures: activatedFeatures,
                actionsPerformed: actionsPerformed,
                isActive: isActive,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CaregiverSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$OfflineDatabase,
      $CaregiverSessionsTable,
      CaregiverSession,
      $$CaregiverSessionsTableFilterComposer,
      $$CaregiverSessionsTableOrderingComposer,
      $$CaregiverSessionsTableAnnotationComposer,
      $$CaregiverSessionsTableCreateCompanionBuilder,
      $$CaregiverSessionsTableUpdateCompanionBuilder,
      (
        CaregiverSession,
        BaseReferences<
          _$OfflineDatabase,
          $CaregiverSessionsTable,
          CaregiverSession
        >,
      ),
      CaregiverSession,
      PrefetchHooks Function()
    >;

class $OfflineDatabaseManager {
  final _$OfflineDatabase _db;
  $OfflineDatabaseManager(this._db);
  $$PatientProfilesTableTableManager get patientProfiles =>
      $$PatientProfilesTableTableManager(_db, _db.patientProfiles);
  $$UserProfilesTableTableManager get userProfiles =>
      $$UserProfilesTableTableManager(_db, _db.userProfiles);
  $$OfflineAppointmentsTableTableManager get offlineAppointments =>
      $$OfflineAppointmentsTableTableManager(_db, _db.offlineAppointments);
  $$CachedPrescriptionsTableTableManager get cachedPrescriptions =>
      $$CachedPrescriptionsTableTableManager(_db, _db.cachedPrescriptions);
  $$OfflineSymptomChecksTableTableManager get offlineSymptomChecks =>
      $$OfflineSymptomChecksTableTableManager(_db, _db.offlineSymptomChecks);
  $$SyncQueuesTableTableManager get syncQueues =>
      $$SyncQueuesTableTableManager(_db, _db.syncQueues);
  $$MedicalReportsTableTableManager get medicalReports =>
      $$MedicalReportsTableTableManager(_db, _db.medicalReports);
  $$VitalSignsTableTableManager get vitalSigns =>
      $$VitalSignsTableTableManager(_db, _db.vitalSigns);
  $$FamilyMembersTableTableManager get familyMembers =>
      $$FamilyMembersTableTableManager(_db, _db.familyMembers);
  $$FamilyGroupsTableTableManager get familyGroups =>
      $$FamilyGroupsTableTableManager(_db, _db.familyGroups);
  $$FamilyHealthRecordsTableTableManager get familyHealthRecords =>
      $$FamilyHealthRecordsTableTableManager(_db, _db.familyHealthRecords);
  $$CaregiverSessionsTableTableManager get caregiverSessions =>
      $$CaregiverSessionsTableTableManager(_db, _db.caregiverSessions);
}
