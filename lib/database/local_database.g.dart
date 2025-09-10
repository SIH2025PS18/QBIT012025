// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_database.dart';

// ignore_for_file: type=lint
class $LocalPatientProfilesTable extends LocalPatientProfiles
    with TableInfo<$LocalPatientProfilesTable, LocalPatientProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalPatientProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
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
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dateOfBirthMeta = const VerificationMeta(
    'dateOfBirth',
  );
  @override
  late final GeneratedColumn<DateTime> dateOfBirth = GeneratedColumn<DateTime>(
    'date_of_birth',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _genderMeta = const VerificationMeta('gender');
  @override
  late final GeneratedColumn<String> gender = GeneratedColumn<String>(
    'gender',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
  static const VerificationMeta _emergencyContactPhoneMeta =
      const VerificationMeta('emergencyContactPhone');
  @override
  late final GeneratedColumn<String> emergencyContactPhone =
      GeneratedColumn<String>(
        'emergency_contact_phone',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _profilePhotoUrlMeta = const VerificationMeta(
    'profilePhotoUrl',
  );
  @override
  late final GeneratedColumn<String> profilePhotoUrl = GeneratedColumn<String>(
    'profile_photo_url',
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
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
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
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _medicalHistoryMeta = const VerificationMeta(
    'medicalHistory',
  );
  @override
  late final GeneratedColumn<String> medicalHistory = GeneratedColumn<String>(
    'medical_history',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  static const VerificationMeta _lastVisitMeta = const VerificationMeta(
    'lastVisit',
  );
  @override
  late final GeneratedColumn<DateTime> lastVisit = GeneratedColumn<DateTime>(
    'last_visit',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
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
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
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
  static const VerificationMeta _lastSyncAtMeta = const VerificationMeta(
    'lastSyncAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastSyncAt = GeneratedColumn<DateTime>(
    'last_sync_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pendingDeleteMeta = const VerificationMeta(
    'pendingDelete',
  );
  @override
  late final GeneratedColumn<bool> pendingDelete = GeneratedColumn<bool>(
    'pending_delete',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("pending_delete" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _syncVersionMeta = const VerificationMeta(
    'syncVersion',
  );
  @override
  late final GeneratedColumn<String> syncVersion = GeneratedColumn<String>(
    'sync_version',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('1'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    fullName,
    email,
    phoneNumber,
    dateOfBirth,
    gender,
    bloodGroup,
    address,
    emergencyContact,
    emergencyContactPhone,
    profilePhotoUrl,
    allergies,
    medications,
    medicalHistory,
    lastVisit,
    createdAt,
    updatedAt,
    isSynced,
    lastSyncAt,
    pendingDelete,
    syncVersion,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_patient_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalPatientProfile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
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
    } else if (isInserting) {
      context.missing(_emailMeta);
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
    if (data.containsKey('date_of_birth')) {
      context.handle(
        _dateOfBirthMeta,
        dateOfBirth.isAcceptableOrUnknown(
          data['date_of_birth']!,
          _dateOfBirthMeta,
        ),
      );
    }
    if (data.containsKey('gender')) {
      context.handle(
        _genderMeta,
        gender.isAcceptableOrUnknown(data['gender']!, _genderMeta),
      );
    }
    if (data.containsKey('blood_group')) {
      context.handle(
        _bloodGroupMeta,
        bloodGroup.isAcceptableOrUnknown(data['blood_group']!, _bloodGroupMeta),
      );
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
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
    if (data.containsKey('emergency_contact_phone')) {
      context.handle(
        _emergencyContactPhoneMeta,
        emergencyContactPhone.isAcceptableOrUnknown(
          data['emergency_contact_phone']!,
          _emergencyContactPhoneMeta,
        ),
      );
    }
    if (data.containsKey('profile_photo_url')) {
      context.handle(
        _profilePhotoUrlMeta,
        profilePhotoUrl.isAcceptableOrUnknown(
          data['profile_photo_url']!,
          _profilePhotoUrlMeta,
        ),
      );
    }
    if (data.containsKey('allergies')) {
      context.handle(
        _allergiesMeta,
        allergies.isAcceptableOrUnknown(data['allergies']!, _allergiesMeta),
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
    if (data.containsKey('medical_history')) {
      context.handle(
        _medicalHistoryMeta,
        medicalHistory.isAcceptableOrUnknown(
          data['medical_history']!,
          _medicalHistoryMeta,
        ),
      );
    }
    if (data.containsKey('last_visit')) {
      context.handle(
        _lastVisitMeta,
        lastVisit.isAcceptableOrUnknown(data['last_visit']!, _lastVisitMeta),
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
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    if (data.containsKey('last_sync_at')) {
      context.handle(
        _lastSyncAtMeta,
        lastSyncAt.isAcceptableOrUnknown(
          data['last_sync_at']!,
          _lastSyncAtMeta,
        ),
      );
    }
    if (data.containsKey('pending_delete')) {
      context.handle(
        _pendingDeleteMeta,
        pendingDelete.isAcceptableOrUnknown(
          data['pending_delete']!,
          _pendingDeleteMeta,
        ),
      );
    }
    if (data.containsKey('sync_version')) {
      context.handle(
        _syncVersionMeta,
        syncVersion.isAcceptableOrUnknown(
          data['sync_version']!,
          _syncVersionMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalPatientProfile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalPatientProfile(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      fullName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}full_name'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      phoneNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone_number'],
      ),
      dateOfBirth: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date_of_birth'],
      ),
      gender: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gender'],
      ),
      bloodGroup: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}blood_group'],
      ),
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      ),
      emergencyContact: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}emergency_contact'],
      ),
      emergencyContactPhone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}emergency_contact_phone'],
      ),
      profilePhotoUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profile_photo_url'],
      ),
      allergies: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}allergies'],
      )!,
      medications: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}medications'],
      )!,
      medicalHistory: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}medical_history'],
      )!,
      lastVisit: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_visit'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
      lastSyncAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_sync_at'],
      ),
      pendingDelete: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}pending_delete'],
      )!,
      syncVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_version'],
      )!,
    );
  }

  @override
  $LocalPatientProfilesTable createAlias(String alias) {
    return $LocalPatientProfilesTable(attachedDatabase, alias);
  }
}

class LocalPatientProfile extends DataClass
    implements Insertable<LocalPatientProfile> {
  final String id;
  final String fullName;
  final String email;
  final String? phoneNumber;
  final DateTime? dateOfBirth;
  final String? gender;
  final String? bloodGroup;
  final String? address;
  final String? emergencyContact;
  final String? emergencyContactPhone;
  final String? profilePhotoUrl;
  final String allergies;
  final String medications;
  final String medicalHistory;
  final DateTime? lastVisit;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isSynced;
  final DateTime? lastSyncAt;
  final bool pendingDelete;
  final String syncVersion;
  const LocalPatientProfile({
    required this.id,
    required this.fullName,
    required this.email,
    this.phoneNumber,
    this.dateOfBirth,
    this.gender,
    this.bloodGroup,
    this.address,
    this.emergencyContact,
    this.emergencyContactPhone,
    this.profilePhotoUrl,
    required this.allergies,
    required this.medications,
    required this.medicalHistory,
    this.lastVisit,
    required this.createdAt,
    required this.updatedAt,
    required this.isSynced,
    this.lastSyncAt,
    required this.pendingDelete,
    required this.syncVersion,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['full_name'] = Variable<String>(fullName);
    map['email'] = Variable<String>(email);
    if (!nullToAbsent || phoneNumber != null) {
      map['phone_number'] = Variable<String>(phoneNumber);
    }
    if (!nullToAbsent || dateOfBirth != null) {
      map['date_of_birth'] = Variable<DateTime>(dateOfBirth);
    }
    if (!nullToAbsent || gender != null) {
      map['gender'] = Variable<String>(gender);
    }
    if (!nullToAbsent || bloodGroup != null) {
      map['blood_group'] = Variable<String>(bloodGroup);
    }
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    if (!nullToAbsent || emergencyContact != null) {
      map['emergency_contact'] = Variable<String>(emergencyContact);
    }
    if (!nullToAbsent || emergencyContactPhone != null) {
      map['emergency_contact_phone'] = Variable<String>(emergencyContactPhone);
    }
    if (!nullToAbsent || profilePhotoUrl != null) {
      map['profile_photo_url'] = Variable<String>(profilePhotoUrl);
    }
    map['allergies'] = Variable<String>(allergies);
    map['medications'] = Variable<String>(medications);
    map['medical_history'] = Variable<String>(medicalHistory);
    if (!nullToAbsent || lastVisit != null) {
      map['last_visit'] = Variable<DateTime>(lastVisit);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['is_synced'] = Variable<bool>(isSynced);
    if (!nullToAbsent || lastSyncAt != null) {
      map['last_sync_at'] = Variable<DateTime>(lastSyncAt);
    }
    map['pending_delete'] = Variable<bool>(pendingDelete);
    map['sync_version'] = Variable<String>(syncVersion);
    return map;
  }

  LocalPatientProfilesCompanion toCompanion(bool nullToAbsent) {
    return LocalPatientProfilesCompanion(
      id: Value(id),
      fullName: Value(fullName),
      email: Value(email),
      phoneNumber: phoneNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(phoneNumber),
      dateOfBirth: dateOfBirth == null && nullToAbsent
          ? const Value.absent()
          : Value(dateOfBirth),
      gender: gender == null && nullToAbsent
          ? const Value.absent()
          : Value(gender),
      bloodGroup: bloodGroup == null && nullToAbsent
          ? const Value.absent()
          : Value(bloodGroup),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      emergencyContact: emergencyContact == null && nullToAbsent
          ? const Value.absent()
          : Value(emergencyContact),
      emergencyContactPhone: emergencyContactPhone == null && nullToAbsent
          ? const Value.absent()
          : Value(emergencyContactPhone),
      profilePhotoUrl: profilePhotoUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(profilePhotoUrl),
      allergies: Value(allergies),
      medications: Value(medications),
      medicalHistory: Value(medicalHistory),
      lastVisit: lastVisit == null && nullToAbsent
          ? const Value.absent()
          : Value(lastVisit),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      isSynced: Value(isSynced),
      lastSyncAt: lastSyncAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncAt),
      pendingDelete: Value(pendingDelete),
      syncVersion: Value(syncVersion),
    );
  }

  factory LocalPatientProfile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalPatientProfile(
      id: serializer.fromJson<String>(json['id']),
      fullName: serializer.fromJson<String>(json['fullName']),
      email: serializer.fromJson<String>(json['email']),
      phoneNumber: serializer.fromJson<String?>(json['phoneNumber']),
      dateOfBirth: serializer.fromJson<DateTime?>(json['dateOfBirth']),
      gender: serializer.fromJson<String?>(json['gender']),
      bloodGroup: serializer.fromJson<String?>(json['bloodGroup']),
      address: serializer.fromJson<String?>(json['address']),
      emergencyContact: serializer.fromJson<String?>(json['emergencyContact']),
      emergencyContactPhone: serializer.fromJson<String?>(
        json['emergencyContactPhone'],
      ),
      profilePhotoUrl: serializer.fromJson<String?>(json['profilePhotoUrl']),
      allergies: serializer.fromJson<String>(json['allergies']),
      medications: serializer.fromJson<String>(json['medications']),
      medicalHistory: serializer.fromJson<String>(json['medicalHistory']),
      lastVisit: serializer.fromJson<DateTime?>(json['lastVisit']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      lastSyncAt: serializer.fromJson<DateTime?>(json['lastSyncAt']),
      pendingDelete: serializer.fromJson<bool>(json['pendingDelete']),
      syncVersion: serializer.fromJson<String>(json['syncVersion']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'fullName': serializer.toJson<String>(fullName),
      'email': serializer.toJson<String>(email),
      'phoneNumber': serializer.toJson<String?>(phoneNumber),
      'dateOfBirth': serializer.toJson<DateTime?>(dateOfBirth),
      'gender': serializer.toJson<String?>(gender),
      'bloodGroup': serializer.toJson<String?>(bloodGroup),
      'address': serializer.toJson<String?>(address),
      'emergencyContact': serializer.toJson<String?>(emergencyContact),
      'emergencyContactPhone': serializer.toJson<String?>(
        emergencyContactPhone,
      ),
      'profilePhotoUrl': serializer.toJson<String?>(profilePhotoUrl),
      'allergies': serializer.toJson<String>(allergies),
      'medications': serializer.toJson<String>(medications),
      'medicalHistory': serializer.toJson<String>(medicalHistory),
      'lastVisit': serializer.toJson<DateTime?>(lastVisit),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'isSynced': serializer.toJson<bool>(isSynced),
      'lastSyncAt': serializer.toJson<DateTime?>(lastSyncAt),
      'pendingDelete': serializer.toJson<bool>(pendingDelete),
      'syncVersion': serializer.toJson<String>(syncVersion),
    };
  }

  LocalPatientProfile copyWith({
    String? id,
    String? fullName,
    String? email,
    Value<String?> phoneNumber = const Value.absent(),
    Value<DateTime?> dateOfBirth = const Value.absent(),
    Value<String?> gender = const Value.absent(),
    Value<String?> bloodGroup = const Value.absent(),
    Value<String?> address = const Value.absent(),
    Value<String?> emergencyContact = const Value.absent(),
    Value<String?> emergencyContactPhone = const Value.absent(),
    Value<String?> profilePhotoUrl = const Value.absent(),
    String? allergies,
    String? medications,
    String? medicalHistory,
    Value<DateTime?> lastVisit = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isSynced,
    Value<DateTime?> lastSyncAt = const Value.absent(),
    bool? pendingDelete,
    String? syncVersion,
  }) => LocalPatientProfile(
    id: id ?? this.id,
    fullName: fullName ?? this.fullName,
    email: email ?? this.email,
    phoneNumber: phoneNumber.present ? phoneNumber.value : this.phoneNumber,
    dateOfBirth: dateOfBirth.present ? dateOfBirth.value : this.dateOfBirth,
    gender: gender.present ? gender.value : this.gender,
    bloodGroup: bloodGroup.present ? bloodGroup.value : this.bloodGroup,
    address: address.present ? address.value : this.address,
    emergencyContact: emergencyContact.present
        ? emergencyContact.value
        : this.emergencyContact,
    emergencyContactPhone: emergencyContactPhone.present
        ? emergencyContactPhone.value
        : this.emergencyContactPhone,
    profilePhotoUrl: profilePhotoUrl.present
        ? profilePhotoUrl.value
        : this.profilePhotoUrl,
    allergies: allergies ?? this.allergies,
    medications: medications ?? this.medications,
    medicalHistory: medicalHistory ?? this.medicalHistory,
    lastVisit: lastVisit.present ? lastVisit.value : this.lastVisit,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    isSynced: isSynced ?? this.isSynced,
    lastSyncAt: lastSyncAt.present ? lastSyncAt.value : this.lastSyncAt,
    pendingDelete: pendingDelete ?? this.pendingDelete,
    syncVersion: syncVersion ?? this.syncVersion,
  );
  LocalPatientProfile copyWithCompanion(LocalPatientProfilesCompanion data) {
    return LocalPatientProfile(
      id: data.id.present ? data.id.value : this.id,
      fullName: data.fullName.present ? data.fullName.value : this.fullName,
      email: data.email.present ? data.email.value : this.email,
      phoneNumber: data.phoneNumber.present
          ? data.phoneNumber.value
          : this.phoneNumber,
      dateOfBirth: data.dateOfBirth.present
          ? data.dateOfBirth.value
          : this.dateOfBirth,
      gender: data.gender.present ? data.gender.value : this.gender,
      bloodGroup: data.bloodGroup.present
          ? data.bloodGroup.value
          : this.bloodGroup,
      address: data.address.present ? data.address.value : this.address,
      emergencyContact: data.emergencyContact.present
          ? data.emergencyContact.value
          : this.emergencyContact,
      emergencyContactPhone: data.emergencyContactPhone.present
          ? data.emergencyContactPhone.value
          : this.emergencyContactPhone,
      profilePhotoUrl: data.profilePhotoUrl.present
          ? data.profilePhotoUrl.value
          : this.profilePhotoUrl,
      allergies: data.allergies.present ? data.allergies.value : this.allergies,
      medications: data.medications.present
          ? data.medications.value
          : this.medications,
      medicalHistory: data.medicalHistory.present
          ? data.medicalHistory.value
          : this.medicalHistory,
      lastVisit: data.lastVisit.present ? data.lastVisit.value : this.lastVisit,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      lastSyncAt: data.lastSyncAt.present
          ? data.lastSyncAt.value
          : this.lastSyncAt,
      pendingDelete: data.pendingDelete.present
          ? data.pendingDelete.value
          : this.pendingDelete,
      syncVersion: data.syncVersion.present
          ? data.syncVersion.value
          : this.syncVersion,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalPatientProfile(')
          ..write('id: $id, ')
          ..write('fullName: $fullName, ')
          ..write('email: $email, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('dateOfBirth: $dateOfBirth, ')
          ..write('gender: $gender, ')
          ..write('bloodGroup: $bloodGroup, ')
          ..write('address: $address, ')
          ..write('emergencyContact: $emergencyContact, ')
          ..write('emergencyContactPhone: $emergencyContactPhone, ')
          ..write('profilePhotoUrl: $profilePhotoUrl, ')
          ..write('allergies: $allergies, ')
          ..write('medications: $medications, ')
          ..write('medicalHistory: $medicalHistory, ')
          ..write('lastVisit: $lastVisit, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('lastSyncAt: $lastSyncAt, ')
          ..write('pendingDelete: $pendingDelete, ')
          ..write('syncVersion: $syncVersion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    fullName,
    email,
    phoneNumber,
    dateOfBirth,
    gender,
    bloodGroup,
    address,
    emergencyContact,
    emergencyContactPhone,
    profilePhotoUrl,
    allergies,
    medications,
    medicalHistory,
    lastVisit,
    createdAt,
    updatedAt,
    isSynced,
    lastSyncAt,
    pendingDelete,
    syncVersion,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalPatientProfile &&
          other.id == this.id &&
          other.fullName == this.fullName &&
          other.email == this.email &&
          other.phoneNumber == this.phoneNumber &&
          other.dateOfBirth == this.dateOfBirth &&
          other.gender == this.gender &&
          other.bloodGroup == this.bloodGroup &&
          other.address == this.address &&
          other.emergencyContact == this.emergencyContact &&
          other.emergencyContactPhone == this.emergencyContactPhone &&
          other.profilePhotoUrl == this.profilePhotoUrl &&
          other.allergies == this.allergies &&
          other.medications == this.medications &&
          other.medicalHistory == this.medicalHistory &&
          other.lastVisit == this.lastVisit &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.isSynced == this.isSynced &&
          other.lastSyncAt == this.lastSyncAt &&
          other.pendingDelete == this.pendingDelete &&
          other.syncVersion == this.syncVersion);
}

class LocalPatientProfilesCompanion
    extends UpdateCompanion<LocalPatientProfile> {
  final Value<String> id;
  final Value<String> fullName;
  final Value<String> email;
  final Value<String?> phoneNumber;
  final Value<DateTime?> dateOfBirth;
  final Value<String?> gender;
  final Value<String?> bloodGroup;
  final Value<String?> address;
  final Value<String?> emergencyContact;
  final Value<String?> emergencyContactPhone;
  final Value<String?> profilePhotoUrl;
  final Value<String> allergies;
  final Value<String> medications;
  final Value<String> medicalHistory;
  final Value<DateTime?> lastVisit;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> isSynced;
  final Value<DateTime?> lastSyncAt;
  final Value<bool> pendingDelete;
  final Value<String> syncVersion;
  final Value<int> rowid;
  const LocalPatientProfilesCompanion({
    this.id = const Value.absent(),
    this.fullName = const Value.absent(),
    this.email = const Value.absent(),
    this.phoneNumber = const Value.absent(),
    this.dateOfBirth = const Value.absent(),
    this.gender = const Value.absent(),
    this.bloodGroup = const Value.absent(),
    this.address = const Value.absent(),
    this.emergencyContact = const Value.absent(),
    this.emergencyContactPhone = const Value.absent(),
    this.profilePhotoUrl = const Value.absent(),
    this.allergies = const Value.absent(),
    this.medications = const Value.absent(),
    this.medicalHistory = const Value.absent(),
    this.lastVisit = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.lastSyncAt = const Value.absent(),
    this.pendingDelete = const Value.absent(),
    this.syncVersion = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalPatientProfilesCompanion.insert({
    required String id,
    required String fullName,
    required String email,
    this.phoneNumber = const Value.absent(),
    this.dateOfBirth = const Value.absent(),
    this.gender = const Value.absent(),
    this.bloodGroup = const Value.absent(),
    this.address = const Value.absent(),
    this.emergencyContact = const Value.absent(),
    this.emergencyContactPhone = const Value.absent(),
    this.profilePhotoUrl = const Value.absent(),
    this.allergies = const Value.absent(),
    this.medications = const Value.absent(),
    this.medicalHistory = const Value.absent(),
    this.lastVisit = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.isSynced = const Value.absent(),
    this.lastSyncAt = const Value.absent(),
    this.pendingDelete = const Value.absent(),
    this.syncVersion = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       fullName = Value(fullName),
       email = Value(email),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<LocalPatientProfile> custom({
    Expression<String>? id,
    Expression<String>? fullName,
    Expression<String>? email,
    Expression<String>? phoneNumber,
    Expression<DateTime>? dateOfBirth,
    Expression<String>? gender,
    Expression<String>? bloodGroup,
    Expression<String>? address,
    Expression<String>? emergencyContact,
    Expression<String>? emergencyContactPhone,
    Expression<String>? profilePhotoUrl,
    Expression<String>? allergies,
    Expression<String>? medications,
    Expression<String>? medicalHistory,
    Expression<DateTime>? lastVisit,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isSynced,
    Expression<DateTime>? lastSyncAt,
    Expression<bool>? pendingDelete,
    Expression<String>? syncVersion,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (fullName != null) 'full_name': fullName,
      if (email != null) 'email': email,
      if (phoneNumber != null) 'phone_number': phoneNumber,
      if (dateOfBirth != null) 'date_of_birth': dateOfBirth,
      if (gender != null) 'gender': gender,
      if (bloodGroup != null) 'blood_group': bloodGroup,
      if (address != null) 'address': address,
      if (emergencyContact != null) 'emergency_contact': emergencyContact,
      if (emergencyContactPhone != null)
        'emergency_contact_phone': emergencyContactPhone,
      if (profilePhotoUrl != null) 'profile_photo_url': profilePhotoUrl,
      if (allergies != null) 'allergies': allergies,
      if (medications != null) 'medications': medications,
      if (medicalHistory != null) 'medical_history': medicalHistory,
      if (lastVisit != null) 'last_visit': lastVisit,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isSynced != null) 'is_synced': isSynced,
      if (lastSyncAt != null) 'last_sync_at': lastSyncAt,
      if (pendingDelete != null) 'pending_delete': pendingDelete,
      if (syncVersion != null) 'sync_version': syncVersion,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalPatientProfilesCompanion copyWith({
    Value<String>? id,
    Value<String>? fullName,
    Value<String>? email,
    Value<String?>? phoneNumber,
    Value<DateTime?>? dateOfBirth,
    Value<String?>? gender,
    Value<String?>? bloodGroup,
    Value<String?>? address,
    Value<String?>? emergencyContact,
    Value<String?>? emergencyContactPhone,
    Value<String?>? profilePhotoUrl,
    Value<String>? allergies,
    Value<String>? medications,
    Value<String>? medicalHistory,
    Value<DateTime?>? lastVisit,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<bool>? isSynced,
    Value<DateTime?>? lastSyncAt,
    Value<bool>? pendingDelete,
    Value<String>? syncVersion,
    Value<int>? rowid,
  }) {
    return LocalPatientProfilesCompanion(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      address: address ?? this.address,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      emergencyContactPhone:
          emergencyContactPhone ?? this.emergencyContactPhone,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
      allergies: allergies ?? this.allergies,
      medications: medications ?? this.medications,
      medicalHistory: medicalHistory ?? this.medicalHistory,
      lastVisit: lastVisit ?? this.lastVisit,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
      pendingDelete: pendingDelete ?? this.pendingDelete,
      syncVersion: syncVersion ?? this.syncVersion,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (fullName.present) {
      map['full_name'] = Variable<String>(fullName.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (phoneNumber.present) {
      map['phone_number'] = Variable<String>(phoneNumber.value);
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
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (emergencyContact.present) {
      map['emergency_contact'] = Variable<String>(emergencyContact.value);
    }
    if (emergencyContactPhone.present) {
      map['emergency_contact_phone'] = Variable<String>(
        emergencyContactPhone.value,
      );
    }
    if (profilePhotoUrl.present) {
      map['profile_photo_url'] = Variable<String>(profilePhotoUrl.value);
    }
    if (allergies.present) {
      map['allergies'] = Variable<String>(allergies.value);
    }
    if (medications.present) {
      map['medications'] = Variable<String>(medications.value);
    }
    if (medicalHistory.present) {
      map['medical_history'] = Variable<String>(medicalHistory.value);
    }
    if (lastVisit.present) {
      map['last_visit'] = Variable<DateTime>(lastVisit.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (lastSyncAt.present) {
      map['last_sync_at'] = Variable<DateTime>(lastSyncAt.value);
    }
    if (pendingDelete.present) {
      map['pending_delete'] = Variable<bool>(pendingDelete.value);
    }
    if (syncVersion.present) {
      map['sync_version'] = Variable<String>(syncVersion.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalPatientProfilesCompanion(')
          ..write('id: $id, ')
          ..write('fullName: $fullName, ')
          ..write('email: $email, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('dateOfBirth: $dateOfBirth, ')
          ..write('gender: $gender, ')
          ..write('bloodGroup: $bloodGroup, ')
          ..write('address: $address, ')
          ..write('emergencyContact: $emergencyContact, ')
          ..write('emergencyContactPhone: $emergencyContactPhone, ')
          ..write('profilePhotoUrl: $profilePhotoUrl, ')
          ..write('allergies: $allergies, ')
          ..write('medications: $medications, ')
          ..write('medicalHistory: $medicalHistory, ')
          ..write('lastVisit: $lastVisit, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('lastSyncAt: $lastSyncAt, ')
          ..write('pendingDelete: $pendingDelete, ')
          ..write('syncVersion: $syncVersion, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalDoctorsTable extends LocalDoctors
    with TableInfo<$LocalDoctorsTable, LocalDoctor> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalDoctorsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
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
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _specializationMeta = const VerificationMeta(
    'specialization',
  );
  @override
  late final GeneratedColumn<String> specialization = GeneratedColumn<String>(
    'specialization',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _qualificationMeta = const VerificationMeta(
    'qualification',
  );
  @override
  late final GeneratedColumn<String> qualification = GeneratedColumn<String>(
    'qualification',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _experienceMeta = const VerificationMeta(
    'experience',
  );
  @override
  late final GeneratedColumn<String> experience = GeneratedColumn<String>(
    'experience',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _profilePhotoUrlMeta = const VerificationMeta(
    'profilePhotoUrl',
  );
  @override
  late final GeneratedColumn<String> profilePhotoUrl = GeneratedColumn<String>(
    'profile_photo_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _aboutMeta = const VerificationMeta('about');
  @override
  late final GeneratedColumn<String> about = GeneratedColumn<String>(
    'about',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ratingMeta = const VerificationMeta('rating');
  @override
  late final GeneratedColumn<double> rating = GeneratedColumn<double>(
    'rating',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _totalReviewsMeta = const VerificationMeta(
    'totalReviews',
  );
  @override
  late final GeneratedColumn<int> totalReviews = GeneratedColumn<int>(
    'total_reviews',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _consultationFeeMeta = const VerificationMeta(
    'consultationFee',
  );
  @override
  late final GeneratedColumn<double> consultationFee = GeneratedColumn<double>(
    'consultation_fee',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isAvailableMeta = const VerificationMeta(
    'isAvailable',
  );
  @override
  late final GeneratedColumn<bool> isAvailable = GeneratedColumn<bool>(
    'is_available',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_available" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
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
  static const VerificationMeta _availableSlotsMeta = const VerificationMeta(
    'availableSlots',
  );
  @override
  late final GeneratedColumn<String> availableSlots = GeneratedColumn<String>(
    'available_slots',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
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
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
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
  static const VerificationMeta _lastSyncAtMeta = const VerificationMeta(
    'lastSyncAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastSyncAt = GeneratedColumn<DateTime>(
    'last_sync_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pendingDeleteMeta = const VerificationMeta(
    'pendingDelete',
  );
  @override
  late final GeneratedColumn<bool> pendingDelete = GeneratedColumn<bool>(
    'pending_delete',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("pending_delete" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _syncVersionMeta = const VerificationMeta(
    'syncVersion',
  );
  @override
  late final GeneratedColumn<String> syncVersion = GeneratedColumn<String>(
    'sync_version',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('1'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    fullName,
    email,
    phoneNumber,
    specialization,
    qualification,
    experience,
    profilePhotoUrl,
    about,
    rating,
    totalReviews,
    consultationFee,
    isAvailable,
    isOnline,
    availableSlots,
    createdAt,
    updatedAt,
    isSynced,
    lastSyncAt,
    pendingDelete,
    syncVersion,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_doctors';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalDoctor> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
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
    } else if (isInserting) {
      context.missing(_emailMeta);
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
    if (data.containsKey('specialization')) {
      context.handle(
        _specializationMeta,
        specialization.isAcceptableOrUnknown(
          data['specialization']!,
          _specializationMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_specializationMeta);
    }
    if (data.containsKey('qualification')) {
      context.handle(
        _qualificationMeta,
        qualification.isAcceptableOrUnknown(
          data['qualification']!,
          _qualificationMeta,
        ),
      );
    }
    if (data.containsKey('experience')) {
      context.handle(
        _experienceMeta,
        experience.isAcceptableOrUnknown(data['experience']!, _experienceMeta),
      );
    }
    if (data.containsKey('profile_photo_url')) {
      context.handle(
        _profilePhotoUrlMeta,
        profilePhotoUrl.isAcceptableOrUnknown(
          data['profile_photo_url']!,
          _profilePhotoUrlMeta,
        ),
      );
    }
    if (data.containsKey('about')) {
      context.handle(
        _aboutMeta,
        about.isAcceptableOrUnknown(data['about']!, _aboutMeta),
      );
    }
    if (data.containsKey('rating')) {
      context.handle(
        _ratingMeta,
        rating.isAcceptableOrUnknown(data['rating']!, _ratingMeta),
      );
    }
    if (data.containsKey('total_reviews')) {
      context.handle(
        _totalReviewsMeta,
        totalReviews.isAcceptableOrUnknown(
          data['total_reviews']!,
          _totalReviewsMeta,
        ),
      );
    }
    if (data.containsKey('consultation_fee')) {
      context.handle(
        _consultationFeeMeta,
        consultationFee.isAcceptableOrUnknown(
          data['consultation_fee']!,
          _consultationFeeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_consultationFeeMeta);
    }
    if (data.containsKey('is_available')) {
      context.handle(
        _isAvailableMeta,
        isAvailable.isAcceptableOrUnknown(
          data['is_available']!,
          _isAvailableMeta,
        ),
      );
    }
    if (data.containsKey('is_online')) {
      context.handle(
        _isOnlineMeta,
        isOnline.isAcceptableOrUnknown(data['is_online']!, _isOnlineMeta),
      );
    }
    if (data.containsKey('available_slots')) {
      context.handle(
        _availableSlotsMeta,
        availableSlots.isAcceptableOrUnknown(
          data['available_slots']!,
          _availableSlotsMeta,
        ),
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
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    if (data.containsKey('last_sync_at')) {
      context.handle(
        _lastSyncAtMeta,
        lastSyncAt.isAcceptableOrUnknown(
          data['last_sync_at']!,
          _lastSyncAtMeta,
        ),
      );
    }
    if (data.containsKey('pending_delete')) {
      context.handle(
        _pendingDeleteMeta,
        pendingDelete.isAcceptableOrUnknown(
          data['pending_delete']!,
          _pendingDeleteMeta,
        ),
      );
    }
    if (data.containsKey('sync_version')) {
      context.handle(
        _syncVersionMeta,
        syncVersion.isAcceptableOrUnknown(
          data['sync_version']!,
          _syncVersionMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalDoctor map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalDoctor(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      fullName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}full_name'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      phoneNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone_number'],
      ),
      specialization: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}specialization'],
      )!,
      qualification: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}qualification'],
      ),
      experience: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}experience'],
      ),
      profilePhotoUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profile_photo_url'],
      ),
      about: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}about'],
      ),
      rating: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}rating'],
      )!,
      totalReviews: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_reviews'],
      )!,
      consultationFee: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}consultation_fee'],
      )!,
      isAvailable: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_available'],
      )!,
      isOnline: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_online'],
      )!,
      availableSlots: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}available_slots'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
      lastSyncAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_sync_at'],
      ),
      pendingDelete: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}pending_delete'],
      )!,
      syncVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_version'],
      )!,
    );
  }

  @override
  $LocalDoctorsTable createAlias(String alias) {
    return $LocalDoctorsTable(attachedDatabase, alias);
  }
}

class LocalDoctor extends DataClass implements Insertable<LocalDoctor> {
  final String id;
  final String fullName;
  final String email;
  final String? phoneNumber;
  final String specialization;
  final String? qualification;
  final String? experience;
  final String? profilePhotoUrl;
  final String? about;
  final double rating;
  final int totalReviews;
  final double consultationFee;
  final bool isAvailable;
  final bool isOnline;
  final String availableSlots;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isSynced;
  final DateTime? lastSyncAt;
  final bool pendingDelete;
  final String syncVersion;
  const LocalDoctor({
    required this.id,
    required this.fullName,
    required this.email,
    this.phoneNumber,
    required this.specialization,
    this.qualification,
    this.experience,
    this.profilePhotoUrl,
    this.about,
    required this.rating,
    required this.totalReviews,
    required this.consultationFee,
    required this.isAvailable,
    required this.isOnline,
    required this.availableSlots,
    required this.createdAt,
    required this.updatedAt,
    required this.isSynced,
    this.lastSyncAt,
    required this.pendingDelete,
    required this.syncVersion,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['full_name'] = Variable<String>(fullName);
    map['email'] = Variable<String>(email);
    if (!nullToAbsent || phoneNumber != null) {
      map['phone_number'] = Variable<String>(phoneNumber);
    }
    map['specialization'] = Variable<String>(specialization);
    if (!nullToAbsent || qualification != null) {
      map['qualification'] = Variable<String>(qualification);
    }
    if (!nullToAbsent || experience != null) {
      map['experience'] = Variable<String>(experience);
    }
    if (!nullToAbsent || profilePhotoUrl != null) {
      map['profile_photo_url'] = Variable<String>(profilePhotoUrl);
    }
    if (!nullToAbsent || about != null) {
      map['about'] = Variable<String>(about);
    }
    map['rating'] = Variable<double>(rating);
    map['total_reviews'] = Variable<int>(totalReviews);
    map['consultation_fee'] = Variable<double>(consultationFee);
    map['is_available'] = Variable<bool>(isAvailable);
    map['is_online'] = Variable<bool>(isOnline);
    map['available_slots'] = Variable<String>(availableSlots);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['is_synced'] = Variable<bool>(isSynced);
    if (!nullToAbsent || lastSyncAt != null) {
      map['last_sync_at'] = Variable<DateTime>(lastSyncAt);
    }
    map['pending_delete'] = Variable<bool>(pendingDelete);
    map['sync_version'] = Variable<String>(syncVersion);
    return map;
  }

  LocalDoctorsCompanion toCompanion(bool nullToAbsent) {
    return LocalDoctorsCompanion(
      id: Value(id),
      fullName: Value(fullName),
      email: Value(email),
      phoneNumber: phoneNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(phoneNumber),
      specialization: Value(specialization),
      qualification: qualification == null && nullToAbsent
          ? const Value.absent()
          : Value(qualification),
      experience: experience == null && nullToAbsent
          ? const Value.absent()
          : Value(experience),
      profilePhotoUrl: profilePhotoUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(profilePhotoUrl),
      about: about == null && nullToAbsent
          ? const Value.absent()
          : Value(about),
      rating: Value(rating),
      totalReviews: Value(totalReviews),
      consultationFee: Value(consultationFee),
      isAvailable: Value(isAvailable),
      isOnline: Value(isOnline),
      availableSlots: Value(availableSlots),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      isSynced: Value(isSynced),
      lastSyncAt: lastSyncAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncAt),
      pendingDelete: Value(pendingDelete),
      syncVersion: Value(syncVersion),
    );
  }

  factory LocalDoctor.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalDoctor(
      id: serializer.fromJson<String>(json['id']),
      fullName: serializer.fromJson<String>(json['fullName']),
      email: serializer.fromJson<String>(json['email']),
      phoneNumber: serializer.fromJson<String?>(json['phoneNumber']),
      specialization: serializer.fromJson<String>(json['specialization']),
      qualification: serializer.fromJson<String?>(json['qualification']),
      experience: serializer.fromJson<String?>(json['experience']),
      profilePhotoUrl: serializer.fromJson<String?>(json['profilePhotoUrl']),
      about: serializer.fromJson<String?>(json['about']),
      rating: serializer.fromJson<double>(json['rating']),
      totalReviews: serializer.fromJson<int>(json['totalReviews']),
      consultationFee: serializer.fromJson<double>(json['consultationFee']),
      isAvailable: serializer.fromJson<bool>(json['isAvailable']),
      isOnline: serializer.fromJson<bool>(json['isOnline']),
      availableSlots: serializer.fromJson<String>(json['availableSlots']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      lastSyncAt: serializer.fromJson<DateTime?>(json['lastSyncAt']),
      pendingDelete: serializer.fromJson<bool>(json['pendingDelete']),
      syncVersion: serializer.fromJson<String>(json['syncVersion']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'fullName': serializer.toJson<String>(fullName),
      'email': serializer.toJson<String>(email),
      'phoneNumber': serializer.toJson<String?>(phoneNumber),
      'specialization': serializer.toJson<String>(specialization),
      'qualification': serializer.toJson<String?>(qualification),
      'experience': serializer.toJson<String?>(experience),
      'profilePhotoUrl': serializer.toJson<String?>(profilePhotoUrl),
      'about': serializer.toJson<String?>(about),
      'rating': serializer.toJson<double>(rating),
      'totalReviews': serializer.toJson<int>(totalReviews),
      'consultationFee': serializer.toJson<double>(consultationFee),
      'isAvailable': serializer.toJson<bool>(isAvailable),
      'isOnline': serializer.toJson<bool>(isOnline),
      'availableSlots': serializer.toJson<String>(availableSlots),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'isSynced': serializer.toJson<bool>(isSynced),
      'lastSyncAt': serializer.toJson<DateTime?>(lastSyncAt),
      'pendingDelete': serializer.toJson<bool>(pendingDelete),
      'syncVersion': serializer.toJson<String>(syncVersion),
    };
  }

  LocalDoctor copyWith({
    String? id,
    String? fullName,
    String? email,
    Value<String?> phoneNumber = const Value.absent(),
    String? specialization,
    Value<String?> qualification = const Value.absent(),
    Value<String?> experience = const Value.absent(),
    Value<String?> profilePhotoUrl = const Value.absent(),
    Value<String?> about = const Value.absent(),
    double? rating,
    int? totalReviews,
    double? consultationFee,
    bool? isAvailable,
    bool? isOnline,
    String? availableSlots,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isSynced,
    Value<DateTime?> lastSyncAt = const Value.absent(),
    bool? pendingDelete,
    String? syncVersion,
  }) => LocalDoctor(
    id: id ?? this.id,
    fullName: fullName ?? this.fullName,
    email: email ?? this.email,
    phoneNumber: phoneNumber.present ? phoneNumber.value : this.phoneNumber,
    specialization: specialization ?? this.specialization,
    qualification: qualification.present
        ? qualification.value
        : this.qualification,
    experience: experience.present ? experience.value : this.experience,
    profilePhotoUrl: profilePhotoUrl.present
        ? profilePhotoUrl.value
        : this.profilePhotoUrl,
    about: about.present ? about.value : this.about,
    rating: rating ?? this.rating,
    totalReviews: totalReviews ?? this.totalReviews,
    consultationFee: consultationFee ?? this.consultationFee,
    isAvailable: isAvailable ?? this.isAvailable,
    isOnline: isOnline ?? this.isOnline,
    availableSlots: availableSlots ?? this.availableSlots,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    isSynced: isSynced ?? this.isSynced,
    lastSyncAt: lastSyncAt.present ? lastSyncAt.value : this.lastSyncAt,
    pendingDelete: pendingDelete ?? this.pendingDelete,
    syncVersion: syncVersion ?? this.syncVersion,
  );
  LocalDoctor copyWithCompanion(LocalDoctorsCompanion data) {
    return LocalDoctor(
      id: data.id.present ? data.id.value : this.id,
      fullName: data.fullName.present ? data.fullName.value : this.fullName,
      email: data.email.present ? data.email.value : this.email,
      phoneNumber: data.phoneNumber.present
          ? data.phoneNumber.value
          : this.phoneNumber,
      specialization: data.specialization.present
          ? data.specialization.value
          : this.specialization,
      qualification: data.qualification.present
          ? data.qualification.value
          : this.qualification,
      experience: data.experience.present
          ? data.experience.value
          : this.experience,
      profilePhotoUrl: data.profilePhotoUrl.present
          ? data.profilePhotoUrl.value
          : this.profilePhotoUrl,
      about: data.about.present ? data.about.value : this.about,
      rating: data.rating.present ? data.rating.value : this.rating,
      totalReviews: data.totalReviews.present
          ? data.totalReviews.value
          : this.totalReviews,
      consultationFee: data.consultationFee.present
          ? data.consultationFee.value
          : this.consultationFee,
      isAvailable: data.isAvailable.present
          ? data.isAvailable.value
          : this.isAvailable,
      isOnline: data.isOnline.present ? data.isOnline.value : this.isOnline,
      availableSlots: data.availableSlots.present
          ? data.availableSlots.value
          : this.availableSlots,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      lastSyncAt: data.lastSyncAt.present
          ? data.lastSyncAt.value
          : this.lastSyncAt,
      pendingDelete: data.pendingDelete.present
          ? data.pendingDelete.value
          : this.pendingDelete,
      syncVersion: data.syncVersion.present
          ? data.syncVersion.value
          : this.syncVersion,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalDoctor(')
          ..write('id: $id, ')
          ..write('fullName: $fullName, ')
          ..write('email: $email, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('specialization: $specialization, ')
          ..write('qualification: $qualification, ')
          ..write('experience: $experience, ')
          ..write('profilePhotoUrl: $profilePhotoUrl, ')
          ..write('about: $about, ')
          ..write('rating: $rating, ')
          ..write('totalReviews: $totalReviews, ')
          ..write('consultationFee: $consultationFee, ')
          ..write('isAvailable: $isAvailable, ')
          ..write('isOnline: $isOnline, ')
          ..write('availableSlots: $availableSlots, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('lastSyncAt: $lastSyncAt, ')
          ..write('pendingDelete: $pendingDelete, ')
          ..write('syncVersion: $syncVersion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    fullName,
    email,
    phoneNumber,
    specialization,
    qualification,
    experience,
    profilePhotoUrl,
    about,
    rating,
    totalReviews,
    consultationFee,
    isAvailable,
    isOnline,
    availableSlots,
    createdAt,
    updatedAt,
    isSynced,
    lastSyncAt,
    pendingDelete,
    syncVersion,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalDoctor &&
          other.id == this.id &&
          other.fullName == this.fullName &&
          other.email == this.email &&
          other.phoneNumber == this.phoneNumber &&
          other.specialization == this.specialization &&
          other.qualification == this.qualification &&
          other.experience == this.experience &&
          other.profilePhotoUrl == this.profilePhotoUrl &&
          other.about == this.about &&
          other.rating == this.rating &&
          other.totalReviews == this.totalReviews &&
          other.consultationFee == this.consultationFee &&
          other.isAvailable == this.isAvailable &&
          other.isOnline == this.isOnline &&
          other.availableSlots == this.availableSlots &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.isSynced == this.isSynced &&
          other.lastSyncAt == this.lastSyncAt &&
          other.pendingDelete == this.pendingDelete &&
          other.syncVersion == this.syncVersion);
}

class LocalDoctorsCompanion extends UpdateCompanion<LocalDoctor> {
  final Value<String> id;
  final Value<String> fullName;
  final Value<String> email;
  final Value<String?> phoneNumber;
  final Value<String> specialization;
  final Value<String?> qualification;
  final Value<String?> experience;
  final Value<String?> profilePhotoUrl;
  final Value<String?> about;
  final Value<double> rating;
  final Value<int> totalReviews;
  final Value<double> consultationFee;
  final Value<bool> isAvailable;
  final Value<bool> isOnline;
  final Value<String> availableSlots;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> isSynced;
  final Value<DateTime?> lastSyncAt;
  final Value<bool> pendingDelete;
  final Value<String> syncVersion;
  final Value<int> rowid;
  const LocalDoctorsCompanion({
    this.id = const Value.absent(),
    this.fullName = const Value.absent(),
    this.email = const Value.absent(),
    this.phoneNumber = const Value.absent(),
    this.specialization = const Value.absent(),
    this.qualification = const Value.absent(),
    this.experience = const Value.absent(),
    this.profilePhotoUrl = const Value.absent(),
    this.about = const Value.absent(),
    this.rating = const Value.absent(),
    this.totalReviews = const Value.absent(),
    this.consultationFee = const Value.absent(),
    this.isAvailable = const Value.absent(),
    this.isOnline = const Value.absent(),
    this.availableSlots = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.lastSyncAt = const Value.absent(),
    this.pendingDelete = const Value.absent(),
    this.syncVersion = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalDoctorsCompanion.insert({
    required String id,
    required String fullName,
    required String email,
    this.phoneNumber = const Value.absent(),
    required String specialization,
    this.qualification = const Value.absent(),
    this.experience = const Value.absent(),
    this.profilePhotoUrl = const Value.absent(),
    this.about = const Value.absent(),
    this.rating = const Value.absent(),
    this.totalReviews = const Value.absent(),
    required double consultationFee,
    this.isAvailable = const Value.absent(),
    this.isOnline = const Value.absent(),
    this.availableSlots = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.isSynced = const Value.absent(),
    this.lastSyncAt = const Value.absent(),
    this.pendingDelete = const Value.absent(),
    this.syncVersion = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       fullName = Value(fullName),
       email = Value(email),
       specialization = Value(specialization),
       consultationFee = Value(consultationFee),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<LocalDoctor> custom({
    Expression<String>? id,
    Expression<String>? fullName,
    Expression<String>? email,
    Expression<String>? phoneNumber,
    Expression<String>? specialization,
    Expression<String>? qualification,
    Expression<String>? experience,
    Expression<String>? profilePhotoUrl,
    Expression<String>? about,
    Expression<double>? rating,
    Expression<int>? totalReviews,
    Expression<double>? consultationFee,
    Expression<bool>? isAvailable,
    Expression<bool>? isOnline,
    Expression<String>? availableSlots,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isSynced,
    Expression<DateTime>? lastSyncAt,
    Expression<bool>? pendingDelete,
    Expression<String>? syncVersion,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (fullName != null) 'full_name': fullName,
      if (email != null) 'email': email,
      if (phoneNumber != null) 'phone_number': phoneNumber,
      if (specialization != null) 'specialization': specialization,
      if (qualification != null) 'qualification': qualification,
      if (experience != null) 'experience': experience,
      if (profilePhotoUrl != null) 'profile_photo_url': profilePhotoUrl,
      if (about != null) 'about': about,
      if (rating != null) 'rating': rating,
      if (totalReviews != null) 'total_reviews': totalReviews,
      if (consultationFee != null) 'consultation_fee': consultationFee,
      if (isAvailable != null) 'is_available': isAvailable,
      if (isOnline != null) 'is_online': isOnline,
      if (availableSlots != null) 'available_slots': availableSlots,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isSynced != null) 'is_synced': isSynced,
      if (lastSyncAt != null) 'last_sync_at': lastSyncAt,
      if (pendingDelete != null) 'pending_delete': pendingDelete,
      if (syncVersion != null) 'sync_version': syncVersion,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalDoctorsCompanion copyWith({
    Value<String>? id,
    Value<String>? fullName,
    Value<String>? email,
    Value<String?>? phoneNumber,
    Value<String>? specialization,
    Value<String?>? qualification,
    Value<String?>? experience,
    Value<String?>? profilePhotoUrl,
    Value<String?>? about,
    Value<double>? rating,
    Value<int>? totalReviews,
    Value<double>? consultationFee,
    Value<bool>? isAvailable,
    Value<bool>? isOnline,
    Value<String>? availableSlots,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<bool>? isSynced,
    Value<DateTime?>? lastSyncAt,
    Value<bool>? pendingDelete,
    Value<String>? syncVersion,
    Value<int>? rowid,
  }) {
    return LocalDoctorsCompanion(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      specialization: specialization ?? this.specialization,
      qualification: qualification ?? this.qualification,
      experience: experience ?? this.experience,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
      about: about ?? this.about,
      rating: rating ?? this.rating,
      totalReviews: totalReviews ?? this.totalReviews,
      consultationFee: consultationFee ?? this.consultationFee,
      isAvailable: isAvailable ?? this.isAvailable,
      isOnline: isOnline ?? this.isOnline,
      availableSlots: availableSlots ?? this.availableSlots,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
      pendingDelete: pendingDelete ?? this.pendingDelete,
      syncVersion: syncVersion ?? this.syncVersion,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (fullName.present) {
      map['full_name'] = Variable<String>(fullName.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (phoneNumber.present) {
      map['phone_number'] = Variable<String>(phoneNumber.value);
    }
    if (specialization.present) {
      map['specialization'] = Variable<String>(specialization.value);
    }
    if (qualification.present) {
      map['qualification'] = Variable<String>(qualification.value);
    }
    if (experience.present) {
      map['experience'] = Variable<String>(experience.value);
    }
    if (profilePhotoUrl.present) {
      map['profile_photo_url'] = Variable<String>(profilePhotoUrl.value);
    }
    if (about.present) {
      map['about'] = Variable<String>(about.value);
    }
    if (rating.present) {
      map['rating'] = Variable<double>(rating.value);
    }
    if (totalReviews.present) {
      map['total_reviews'] = Variable<int>(totalReviews.value);
    }
    if (consultationFee.present) {
      map['consultation_fee'] = Variable<double>(consultationFee.value);
    }
    if (isAvailable.present) {
      map['is_available'] = Variable<bool>(isAvailable.value);
    }
    if (isOnline.present) {
      map['is_online'] = Variable<bool>(isOnline.value);
    }
    if (availableSlots.present) {
      map['available_slots'] = Variable<String>(availableSlots.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (lastSyncAt.present) {
      map['last_sync_at'] = Variable<DateTime>(lastSyncAt.value);
    }
    if (pendingDelete.present) {
      map['pending_delete'] = Variable<bool>(pendingDelete.value);
    }
    if (syncVersion.present) {
      map['sync_version'] = Variable<String>(syncVersion.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalDoctorsCompanion(')
          ..write('id: $id, ')
          ..write('fullName: $fullName, ')
          ..write('email: $email, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('specialization: $specialization, ')
          ..write('qualification: $qualification, ')
          ..write('experience: $experience, ')
          ..write('profilePhotoUrl: $profilePhotoUrl, ')
          ..write('about: $about, ')
          ..write('rating: $rating, ')
          ..write('totalReviews: $totalReviews, ')
          ..write('consultationFee: $consultationFee, ')
          ..write('isAvailable: $isAvailable, ')
          ..write('isOnline: $isOnline, ')
          ..write('availableSlots: $availableSlots, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('lastSyncAt: $lastSyncAt, ')
          ..write('pendingDelete: $pendingDelete, ')
          ..write('syncVersion: $syncVersion, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalAppointmentsTable extends LocalAppointments
    with TableInfo<$LocalAppointmentsTable, LocalAppointment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalAppointmentsTable(this.attachedDatabase, [this._alias]);
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
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _doctorSpecializationMeta =
      const VerificationMeta('doctorSpecialization');
  @override
  late final GeneratedColumn<String> doctorSpecialization =
      GeneratedColumn<String>(
        'doctor_specialization',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _appointmentDateMeta = const VerificationMeta(
    'appointmentDate',
  );
  @override
  late final GeneratedColumn<DateTime> appointmentDate =
      GeneratedColumn<DateTime>(
        'appointment_date',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _appointmentTimeMeta = const VerificationMeta(
    'appointmentTime',
  );
  @override
  late final GeneratedColumn<DateTime> appointmentTime =
      GeneratedColumn<DateTime>(
        'appointment_time',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
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
    defaultValue: const Constant('scheduled'),
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
  static const VerificationMeta _patientSymptomsMeta = const VerificationMeta(
    'patientSymptoms',
  );
  @override
  late final GeneratedColumn<String> patientSymptoms = GeneratedColumn<String>(
    'patient_symptoms',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _consultationFeeMeta = const VerificationMeta(
    'consultationFee',
  );
  @override
  late final GeneratedColumn<double> consultationFee = GeneratedColumn<double>(
    'consultation_fee',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
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
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
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
  static const VerificationMeta _lastSyncAtMeta = const VerificationMeta(
    'lastSyncAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastSyncAt = GeneratedColumn<DateTime>(
    'last_sync_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pendingDeleteMeta = const VerificationMeta(
    'pendingDelete',
  );
  @override
  late final GeneratedColumn<bool> pendingDelete = GeneratedColumn<bool>(
    'pending_delete',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("pending_delete" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _syncVersionMeta = const VerificationMeta(
    'syncVersion',
  );
  @override
  late final GeneratedColumn<String> syncVersion = GeneratedColumn<String>(
    'sync_version',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('1'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    patientId,
    doctorId,
    doctorName,
    doctorSpecialization,
    appointmentDate,
    appointmentTime,
    status,
    notes,
    patientSymptoms,
    consultationFee,
    createdAt,
    updatedAt,
    isSynced,
    lastSyncAt,
    pendingDelete,
    syncVersion,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_appointments';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalAppointment> instance, {
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
    }
    if (data.containsKey('doctor_specialization')) {
      context.handle(
        _doctorSpecializationMeta,
        doctorSpecialization.isAcceptableOrUnknown(
          data['doctor_specialization']!,
          _doctorSpecializationMeta,
        ),
      );
    }
    if (data.containsKey('appointment_date')) {
      context.handle(
        _appointmentDateMeta,
        appointmentDate.isAcceptableOrUnknown(
          data['appointment_date']!,
          _appointmentDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_appointmentDateMeta);
    }
    if (data.containsKey('appointment_time')) {
      context.handle(
        _appointmentTimeMeta,
        appointmentTime.isAcceptableOrUnknown(
          data['appointment_time']!,
          _appointmentTimeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_appointmentTimeMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('patient_symptoms')) {
      context.handle(
        _patientSymptomsMeta,
        patientSymptoms.isAcceptableOrUnknown(
          data['patient_symptoms']!,
          _patientSymptomsMeta,
        ),
      );
    }
    if (data.containsKey('consultation_fee')) {
      context.handle(
        _consultationFeeMeta,
        consultationFee.isAcceptableOrUnknown(
          data['consultation_fee']!,
          _consultationFeeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_consultationFeeMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    if (data.containsKey('last_sync_at')) {
      context.handle(
        _lastSyncAtMeta,
        lastSyncAt.isAcceptableOrUnknown(
          data['last_sync_at']!,
          _lastSyncAtMeta,
        ),
      );
    }
    if (data.containsKey('pending_delete')) {
      context.handle(
        _pendingDeleteMeta,
        pendingDelete.isAcceptableOrUnknown(
          data['pending_delete']!,
          _pendingDeleteMeta,
        ),
      );
    }
    if (data.containsKey('sync_version')) {
      context.handle(
        _syncVersionMeta,
        syncVersion.isAcceptableOrUnknown(
          data['sync_version']!,
          _syncVersionMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalAppointment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalAppointment(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
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
      ),
      doctorSpecialization: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}doctor_specialization'],
      ),
      appointmentDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}appointment_date'],
      )!,
      appointmentTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}appointment_time'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      patientSymptoms: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}patient_symptoms'],
      ),
      consultationFee: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}consultation_fee'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
      lastSyncAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_sync_at'],
      ),
      pendingDelete: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}pending_delete'],
      )!,
      syncVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_version'],
      )!,
    );
  }

  @override
  $LocalAppointmentsTable createAlias(String alias) {
    return $LocalAppointmentsTable(attachedDatabase, alias);
  }
}

class LocalAppointment extends DataClass
    implements Insertable<LocalAppointment> {
  final String id;
  final String patientId;
  final String doctorId;
  final String? doctorName;
  final String? doctorSpecialization;
  final DateTime appointmentDate;
  final DateTime appointmentTime;
  final String status;
  final String? notes;
  final String? patientSymptoms;
  final double consultationFee;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isSynced;
  final DateTime? lastSyncAt;
  final bool pendingDelete;
  final String syncVersion;
  const LocalAppointment({
    required this.id,
    required this.patientId,
    required this.doctorId,
    this.doctorName,
    this.doctorSpecialization,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.status,
    this.notes,
    this.patientSymptoms,
    required this.consultationFee,
    required this.createdAt,
    required this.updatedAt,
    required this.isSynced,
    this.lastSyncAt,
    required this.pendingDelete,
    required this.syncVersion,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['patient_id'] = Variable<String>(patientId);
    map['doctor_id'] = Variable<String>(doctorId);
    if (!nullToAbsent || doctorName != null) {
      map['doctor_name'] = Variable<String>(doctorName);
    }
    if (!nullToAbsent || doctorSpecialization != null) {
      map['doctor_specialization'] = Variable<String>(doctorSpecialization);
    }
    map['appointment_date'] = Variable<DateTime>(appointmentDate);
    map['appointment_time'] = Variable<DateTime>(appointmentTime);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || patientSymptoms != null) {
      map['patient_symptoms'] = Variable<String>(patientSymptoms);
    }
    map['consultation_fee'] = Variable<double>(consultationFee);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['is_synced'] = Variable<bool>(isSynced);
    if (!nullToAbsent || lastSyncAt != null) {
      map['last_sync_at'] = Variable<DateTime>(lastSyncAt);
    }
    map['pending_delete'] = Variable<bool>(pendingDelete);
    map['sync_version'] = Variable<String>(syncVersion);
    return map;
  }

  LocalAppointmentsCompanion toCompanion(bool nullToAbsent) {
    return LocalAppointmentsCompanion(
      id: Value(id),
      patientId: Value(patientId),
      doctorId: Value(doctorId),
      doctorName: doctorName == null && nullToAbsent
          ? const Value.absent()
          : Value(doctorName),
      doctorSpecialization: doctorSpecialization == null && nullToAbsent
          ? const Value.absent()
          : Value(doctorSpecialization),
      appointmentDate: Value(appointmentDate),
      appointmentTime: Value(appointmentTime),
      status: Value(status),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      patientSymptoms: patientSymptoms == null && nullToAbsent
          ? const Value.absent()
          : Value(patientSymptoms),
      consultationFee: Value(consultationFee),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      isSynced: Value(isSynced),
      lastSyncAt: lastSyncAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncAt),
      pendingDelete: Value(pendingDelete),
      syncVersion: Value(syncVersion),
    );
  }

  factory LocalAppointment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalAppointment(
      id: serializer.fromJson<String>(json['id']),
      patientId: serializer.fromJson<String>(json['patientId']),
      doctorId: serializer.fromJson<String>(json['doctorId']),
      doctorName: serializer.fromJson<String?>(json['doctorName']),
      doctorSpecialization: serializer.fromJson<String?>(
        json['doctorSpecialization'],
      ),
      appointmentDate: serializer.fromJson<DateTime>(json['appointmentDate']),
      appointmentTime: serializer.fromJson<DateTime>(json['appointmentTime']),
      status: serializer.fromJson<String>(json['status']),
      notes: serializer.fromJson<String?>(json['notes']),
      patientSymptoms: serializer.fromJson<String?>(json['patientSymptoms']),
      consultationFee: serializer.fromJson<double>(json['consultationFee']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      lastSyncAt: serializer.fromJson<DateTime?>(json['lastSyncAt']),
      pendingDelete: serializer.fromJson<bool>(json['pendingDelete']),
      syncVersion: serializer.fromJson<String>(json['syncVersion']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'patientId': serializer.toJson<String>(patientId),
      'doctorId': serializer.toJson<String>(doctorId),
      'doctorName': serializer.toJson<String?>(doctorName),
      'doctorSpecialization': serializer.toJson<String?>(doctorSpecialization),
      'appointmentDate': serializer.toJson<DateTime>(appointmentDate),
      'appointmentTime': serializer.toJson<DateTime>(appointmentTime),
      'status': serializer.toJson<String>(status),
      'notes': serializer.toJson<String?>(notes),
      'patientSymptoms': serializer.toJson<String?>(patientSymptoms),
      'consultationFee': serializer.toJson<double>(consultationFee),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'isSynced': serializer.toJson<bool>(isSynced),
      'lastSyncAt': serializer.toJson<DateTime?>(lastSyncAt),
      'pendingDelete': serializer.toJson<bool>(pendingDelete),
      'syncVersion': serializer.toJson<String>(syncVersion),
    };
  }

  LocalAppointment copyWith({
    String? id,
    String? patientId,
    String? doctorId,
    Value<String?> doctorName = const Value.absent(),
    Value<String?> doctorSpecialization = const Value.absent(),
    DateTime? appointmentDate,
    DateTime? appointmentTime,
    String? status,
    Value<String?> notes = const Value.absent(),
    Value<String?> patientSymptoms = const Value.absent(),
    double? consultationFee,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isSynced,
    Value<DateTime?> lastSyncAt = const Value.absent(),
    bool? pendingDelete,
    String? syncVersion,
  }) => LocalAppointment(
    id: id ?? this.id,
    patientId: patientId ?? this.patientId,
    doctorId: doctorId ?? this.doctorId,
    doctorName: doctorName.present ? doctorName.value : this.doctorName,
    doctorSpecialization: doctorSpecialization.present
        ? doctorSpecialization.value
        : this.doctorSpecialization,
    appointmentDate: appointmentDate ?? this.appointmentDate,
    appointmentTime: appointmentTime ?? this.appointmentTime,
    status: status ?? this.status,
    notes: notes.present ? notes.value : this.notes,
    patientSymptoms: patientSymptoms.present
        ? patientSymptoms.value
        : this.patientSymptoms,
    consultationFee: consultationFee ?? this.consultationFee,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    isSynced: isSynced ?? this.isSynced,
    lastSyncAt: lastSyncAt.present ? lastSyncAt.value : this.lastSyncAt,
    pendingDelete: pendingDelete ?? this.pendingDelete,
    syncVersion: syncVersion ?? this.syncVersion,
  );
  LocalAppointment copyWithCompanion(LocalAppointmentsCompanion data) {
    return LocalAppointment(
      id: data.id.present ? data.id.value : this.id,
      patientId: data.patientId.present ? data.patientId.value : this.patientId,
      doctorId: data.doctorId.present ? data.doctorId.value : this.doctorId,
      doctorName: data.doctorName.present
          ? data.doctorName.value
          : this.doctorName,
      doctorSpecialization: data.doctorSpecialization.present
          ? data.doctorSpecialization.value
          : this.doctorSpecialization,
      appointmentDate: data.appointmentDate.present
          ? data.appointmentDate.value
          : this.appointmentDate,
      appointmentTime: data.appointmentTime.present
          ? data.appointmentTime.value
          : this.appointmentTime,
      status: data.status.present ? data.status.value : this.status,
      notes: data.notes.present ? data.notes.value : this.notes,
      patientSymptoms: data.patientSymptoms.present
          ? data.patientSymptoms.value
          : this.patientSymptoms,
      consultationFee: data.consultationFee.present
          ? data.consultationFee.value
          : this.consultationFee,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      lastSyncAt: data.lastSyncAt.present
          ? data.lastSyncAt.value
          : this.lastSyncAt,
      pendingDelete: data.pendingDelete.present
          ? data.pendingDelete.value
          : this.pendingDelete,
      syncVersion: data.syncVersion.present
          ? data.syncVersion.value
          : this.syncVersion,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalAppointment(')
          ..write('id: $id, ')
          ..write('patientId: $patientId, ')
          ..write('doctorId: $doctorId, ')
          ..write('doctorName: $doctorName, ')
          ..write('doctorSpecialization: $doctorSpecialization, ')
          ..write('appointmentDate: $appointmentDate, ')
          ..write('appointmentTime: $appointmentTime, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('patientSymptoms: $patientSymptoms, ')
          ..write('consultationFee: $consultationFee, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('lastSyncAt: $lastSyncAt, ')
          ..write('pendingDelete: $pendingDelete, ')
          ..write('syncVersion: $syncVersion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    patientId,
    doctorId,
    doctorName,
    doctorSpecialization,
    appointmentDate,
    appointmentTime,
    status,
    notes,
    patientSymptoms,
    consultationFee,
    createdAt,
    updatedAt,
    isSynced,
    lastSyncAt,
    pendingDelete,
    syncVersion,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalAppointment &&
          other.id == this.id &&
          other.patientId == this.patientId &&
          other.doctorId == this.doctorId &&
          other.doctorName == this.doctorName &&
          other.doctorSpecialization == this.doctorSpecialization &&
          other.appointmentDate == this.appointmentDate &&
          other.appointmentTime == this.appointmentTime &&
          other.status == this.status &&
          other.notes == this.notes &&
          other.patientSymptoms == this.patientSymptoms &&
          other.consultationFee == this.consultationFee &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.isSynced == this.isSynced &&
          other.lastSyncAt == this.lastSyncAt &&
          other.pendingDelete == this.pendingDelete &&
          other.syncVersion == this.syncVersion);
}

class LocalAppointmentsCompanion extends UpdateCompanion<LocalAppointment> {
  final Value<String> id;
  final Value<String> patientId;
  final Value<String> doctorId;
  final Value<String?> doctorName;
  final Value<String?> doctorSpecialization;
  final Value<DateTime> appointmentDate;
  final Value<DateTime> appointmentTime;
  final Value<String> status;
  final Value<String?> notes;
  final Value<String?> patientSymptoms;
  final Value<double> consultationFee;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> isSynced;
  final Value<DateTime?> lastSyncAt;
  final Value<bool> pendingDelete;
  final Value<String> syncVersion;
  final Value<int> rowid;
  const LocalAppointmentsCompanion({
    this.id = const Value.absent(),
    this.patientId = const Value.absent(),
    this.doctorId = const Value.absent(),
    this.doctorName = const Value.absent(),
    this.doctorSpecialization = const Value.absent(),
    this.appointmentDate = const Value.absent(),
    this.appointmentTime = const Value.absent(),
    this.status = const Value.absent(),
    this.notes = const Value.absent(),
    this.patientSymptoms = const Value.absent(),
    this.consultationFee = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.lastSyncAt = const Value.absent(),
    this.pendingDelete = const Value.absent(),
    this.syncVersion = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalAppointmentsCompanion.insert({
    required String id,
    required String patientId,
    required String doctorId,
    this.doctorName = const Value.absent(),
    this.doctorSpecialization = const Value.absent(),
    required DateTime appointmentDate,
    required DateTime appointmentTime,
    this.status = const Value.absent(),
    this.notes = const Value.absent(),
    this.patientSymptoms = const Value.absent(),
    required double consultationFee,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.isSynced = const Value.absent(),
    this.lastSyncAt = const Value.absent(),
    this.pendingDelete = const Value.absent(),
    this.syncVersion = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       patientId = Value(patientId),
       doctorId = Value(doctorId),
       appointmentDate = Value(appointmentDate),
       appointmentTime = Value(appointmentTime),
       consultationFee = Value(consultationFee),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<LocalAppointment> custom({
    Expression<String>? id,
    Expression<String>? patientId,
    Expression<String>? doctorId,
    Expression<String>? doctorName,
    Expression<String>? doctorSpecialization,
    Expression<DateTime>? appointmentDate,
    Expression<DateTime>? appointmentTime,
    Expression<String>? status,
    Expression<String>? notes,
    Expression<String>? patientSymptoms,
    Expression<double>? consultationFee,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isSynced,
    Expression<DateTime>? lastSyncAt,
    Expression<bool>? pendingDelete,
    Expression<String>? syncVersion,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (patientId != null) 'patient_id': patientId,
      if (doctorId != null) 'doctor_id': doctorId,
      if (doctorName != null) 'doctor_name': doctorName,
      if (doctorSpecialization != null)
        'doctor_specialization': doctorSpecialization,
      if (appointmentDate != null) 'appointment_date': appointmentDate,
      if (appointmentTime != null) 'appointment_time': appointmentTime,
      if (status != null) 'status': status,
      if (notes != null) 'notes': notes,
      if (patientSymptoms != null) 'patient_symptoms': patientSymptoms,
      if (consultationFee != null) 'consultation_fee': consultationFee,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isSynced != null) 'is_synced': isSynced,
      if (lastSyncAt != null) 'last_sync_at': lastSyncAt,
      if (pendingDelete != null) 'pending_delete': pendingDelete,
      if (syncVersion != null) 'sync_version': syncVersion,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalAppointmentsCompanion copyWith({
    Value<String>? id,
    Value<String>? patientId,
    Value<String>? doctorId,
    Value<String?>? doctorName,
    Value<String?>? doctorSpecialization,
    Value<DateTime>? appointmentDate,
    Value<DateTime>? appointmentTime,
    Value<String>? status,
    Value<String?>? notes,
    Value<String?>? patientSymptoms,
    Value<double>? consultationFee,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<bool>? isSynced,
    Value<DateTime?>? lastSyncAt,
    Value<bool>? pendingDelete,
    Value<String>? syncVersion,
    Value<int>? rowid,
  }) {
    return LocalAppointmentsCompanion(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      doctorId: doctorId ?? this.doctorId,
      doctorName: doctorName ?? this.doctorName,
      doctorSpecialization: doctorSpecialization ?? this.doctorSpecialization,
      appointmentDate: appointmentDate ?? this.appointmentDate,
      appointmentTime: appointmentTime ?? this.appointmentTime,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      patientSymptoms: patientSymptoms ?? this.patientSymptoms,
      consultationFee: consultationFee ?? this.consultationFee,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
      pendingDelete: pendingDelete ?? this.pendingDelete,
      syncVersion: syncVersion ?? this.syncVersion,
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
    if (doctorId.present) {
      map['doctor_id'] = Variable<String>(doctorId.value);
    }
    if (doctorName.present) {
      map['doctor_name'] = Variable<String>(doctorName.value);
    }
    if (doctorSpecialization.present) {
      map['doctor_specialization'] = Variable<String>(
        doctorSpecialization.value,
      );
    }
    if (appointmentDate.present) {
      map['appointment_date'] = Variable<DateTime>(appointmentDate.value);
    }
    if (appointmentTime.present) {
      map['appointment_time'] = Variable<DateTime>(appointmentTime.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (patientSymptoms.present) {
      map['patient_symptoms'] = Variable<String>(patientSymptoms.value);
    }
    if (consultationFee.present) {
      map['consultation_fee'] = Variable<double>(consultationFee.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (lastSyncAt.present) {
      map['last_sync_at'] = Variable<DateTime>(lastSyncAt.value);
    }
    if (pendingDelete.present) {
      map['pending_delete'] = Variable<bool>(pendingDelete.value);
    }
    if (syncVersion.present) {
      map['sync_version'] = Variable<String>(syncVersion.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalAppointmentsCompanion(')
          ..write('id: $id, ')
          ..write('patientId: $patientId, ')
          ..write('doctorId: $doctorId, ')
          ..write('doctorName: $doctorName, ')
          ..write('doctorSpecialization: $doctorSpecialization, ')
          ..write('appointmentDate: $appointmentDate, ')
          ..write('appointmentTime: $appointmentTime, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('patientSymptoms: $patientSymptoms, ')
          ..write('consultationFee: $consultationFee, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('lastSyncAt: $lastSyncAt, ')
          ..write('pendingDelete: $pendingDelete, ')
          ..write('syncVersion: $syncVersion, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalHealthRecordsTable extends LocalHealthRecords
    with TableInfo<$LocalHealthRecordsTable, LocalHealthRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalHealthRecordsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _appointmentIdMeta = const VerificationMeta(
    'appointmentId',
  );
  @override
  late final GeneratedColumn<String> appointmentId = GeneratedColumn<String>(
    'appointment_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
  static const VerificationMeta _attachmentUrlMeta = const VerificationMeta(
    'attachmentUrl',
  );
  @override
  late final GeneratedColumn<String> attachmentUrl = GeneratedColumn<String>(
    'attachment_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _metadataMeta = const VerificationMeta(
    'metadata',
  );
  @override
  late final GeneratedColumn<String> metadata = GeneratedColumn<String>(
    'metadata',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
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
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
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
  static const VerificationMeta _lastSyncAtMeta = const VerificationMeta(
    'lastSyncAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastSyncAt = GeneratedColumn<DateTime>(
    'last_sync_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pendingDeleteMeta = const VerificationMeta(
    'pendingDelete',
  );
  @override
  late final GeneratedColumn<bool> pendingDelete = GeneratedColumn<bool>(
    'pending_delete',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("pending_delete" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _syncVersionMeta = const VerificationMeta(
    'syncVersion',
  );
  @override
  late final GeneratedColumn<String> syncVersion = GeneratedColumn<String>(
    'sync_version',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('1'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    patientId,
    doctorId,
    appointmentId,
    recordType,
    title,
    description,
    attachmentUrl,
    metadata,
    recordDate,
    createdAt,
    updatedAt,
    isSynced,
    lastSyncAt,
    pendingDelete,
    syncVersion,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_health_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalHealthRecord> instance, {
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
    if (data.containsKey('doctor_id')) {
      context.handle(
        _doctorIdMeta,
        doctorId.isAcceptableOrUnknown(data['doctor_id']!, _doctorIdMeta),
      );
    }
    if (data.containsKey('appointment_id')) {
      context.handle(
        _appointmentIdMeta,
        appointmentId.isAcceptableOrUnknown(
          data['appointment_id']!,
          _appointmentIdMeta,
        ),
      );
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
    if (data.containsKey('attachment_url')) {
      context.handle(
        _attachmentUrlMeta,
        attachmentUrl.isAcceptableOrUnknown(
          data['attachment_url']!,
          _attachmentUrlMeta,
        ),
      );
    }
    if (data.containsKey('metadata')) {
      context.handle(
        _metadataMeta,
        metadata.isAcceptableOrUnknown(data['metadata']!, _metadataMeta),
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
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    if (data.containsKey('last_sync_at')) {
      context.handle(
        _lastSyncAtMeta,
        lastSyncAt.isAcceptableOrUnknown(
          data['last_sync_at']!,
          _lastSyncAtMeta,
        ),
      );
    }
    if (data.containsKey('pending_delete')) {
      context.handle(
        _pendingDeleteMeta,
        pendingDelete.isAcceptableOrUnknown(
          data['pending_delete']!,
          _pendingDeleteMeta,
        ),
      );
    }
    if (data.containsKey('sync_version')) {
      context.handle(
        _syncVersionMeta,
        syncVersion.isAcceptableOrUnknown(
          data['sync_version']!,
          _syncVersionMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalHealthRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalHealthRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      patientId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}patient_id'],
      )!,
      doctorId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}doctor_id'],
      ),
      appointmentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}appointment_id'],
      ),
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
      attachmentUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}attachment_url'],
      ),
      metadata: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}metadata'],
      )!,
      recordDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}record_date'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
      lastSyncAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_sync_at'],
      ),
      pendingDelete: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}pending_delete'],
      )!,
      syncVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_version'],
      )!,
    );
  }

  @override
  $LocalHealthRecordsTable createAlias(String alias) {
    return $LocalHealthRecordsTable(attachedDatabase, alias);
  }
}

class LocalHealthRecord extends DataClass
    implements Insertable<LocalHealthRecord> {
  final String id;
  final String patientId;
  final String? doctorId;
  final String? appointmentId;
  final String recordType;
  final String title;
  final String? description;
  final String? attachmentUrl;
  final String metadata;
  final DateTime recordDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isSynced;
  final DateTime? lastSyncAt;
  final bool pendingDelete;
  final String syncVersion;
  const LocalHealthRecord({
    required this.id,
    required this.patientId,
    this.doctorId,
    this.appointmentId,
    required this.recordType,
    required this.title,
    this.description,
    this.attachmentUrl,
    required this.metadata,
    required this.recordDate,
    required this.createdAt,
    required this.updatedAt,
    required this.isSynced,
    this.lastSyncAt,
    required this.pendingDelete,
    required this.syncVersion,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['patient_id'] = Variable<String>(patientId);
    if (!nullToAbsent || doctorId != null) {
      map['doctor_id'] = Variable<String>(doctorId);
    }
    if (!nullToAbsent || appointmentId != null) {
      map['appointment_id'] = Variable<String>(appointmentId);
    }
    map['record_type'] = Variable<String>(recordType);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || attachmentUrl != null) {
      map['attachment_url'] = Variable<String>(attachmentUrl);
    }
    map['metadata'] = Variable<String>(metadata);
    map['record_date'] = Variable<DateTime>(recordDate);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['is_synced'] = Variable<bool>(isSynced);
    if (!nullToAbsent || lastSyncAt != null) {
      map['last_sync_at'] = Variable<DateTime>(lastSyncAt);
    }
    map['pending_delete'] = Variable<bool>(pendingDelete);
    map['sync_version'] = Variable<String>(syncVersion);
    return map;
  }

  LocalHealthRecordsCompanion toCompanion(bool nullToAbsent) {
    return LocalHealthRecordsCompanion(
      id: Value(id),
      patientId: Value(patientId),
      doctorId: doctorId == null && nullToAbsent
          ? const Value.absent()
          : Value(doctorId),
      appointmentId: appointmentId == null && nullToAbsent
          ? const Value.absent()
          : Value(appointmentId),
      recordType: Value(recordType),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      attachmentUrl: attachmentUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(attachmentUrl),
      metadata: Value(metadata),
      recordDate: Value(recordDate),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      isSynced: Value(isSynced),
      lastSyncAt: lastSyncAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncAt),
      pendingDelete: Value(pendingDelete),
      syncVersion: Value(syncVersion),
    );
  }

  factory LocalHealthRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalHealthRecord(
      id: serializer.fromJson<String>(json['id']),
      patientId: serializer.fromJson<String>(json['patientId']),
      doctorId: serializer.fromJson<String?>(json['doctorId']),
      appointmentId: serializer.fromJson<String?>(json['appointmentId']),
      recordType: serializer.fromJson<String>(json['recordType']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      attachmentUrl: serializer.fromJson<String?>(json['attachmentUrl']),
      metadata: serializer.fromJson<String>(json['metadata']),
      recordDate: serializer.fromJson<DateTime>(json['recordDate']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      lastSyncAt: serializer.fromJson<DateTime?>(json['lastSyncAt']),
      pendingDelete: serializer.fromJson<bool>(json['pendingDelete']),
      syncVersion: serializer.fromJson<String>(json['syncVersion']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'patientId': serializer.toJson<String>(patientId),
      'doctorId': serializer.toJson<String?>(doctorId),
      'appointmentId': serializer.toJson<String?>(appointmentId),
      'recordType': serializer.toJson<String>(recordType),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'attachmentUrl': serializer.toJson<String?>(attachmentUrl),
      'metadata': serializer.toJson<String>(metadata),
      'recordDate': serializer.toJson<DateTime>(recordDate),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'isSynced': serializer.toJson<bool>(isSynced),
      'lastSyncAt': serializer.toJson<DateTime?>(lastSyncAt),
      'pendingDelete': serializer.toJson<bool>(pendingDelete),
      'syncVersion': serializer.toJson<String>(syncVersion),
    };
  }

  LocalHealthRecord copyWith({
    String? id,
    String? patientId,
    Value<String?> doctorId = const Value.absent(),
    Value<String?> appointmentId = const Value.absent(),
    String? recordType,
    String? title,
    Value<String?> description = const Value.absent(),
    Value<String?> attachmentUrl = const Value.absent(),
    String? metadata,
    DateTime? recordDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isSynced,
    Value<DateTime?> lastSyncAt = const Value.absent(),
    bool? pendingDelete,
    String? syncVersion,
  }) => LocalHealthRecord(
    id: id ?? this.id,
    patientId: patientId ?? this.patientId,
    doctorId: doctorId.present ? doctorId.value : this.doctorId,
    appointmentId: appointmentId.present
        ? appointmentId.value
        : this.appointmentId,
    recordType: recordType ?? this.recordType,
    title: title ?? this.title,
    description: description.present ? description.value : this.description,
    attachmentUrl: attachmentUrl.present
        ? attachmentUrl.value
        : this.attachmentUrl,
    metadata: metadata ?? this.metadata,
    recordDate: recordDate ?? this.recordDate,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    isSynced: isSynced ?? this.isSynced,
    lastSyncAt: lastSyncAt.present ? lastSyncAt.value : this.lastSyncAt,
    pendingDelete: pendingDelete ?? this.pendingDelete,
    syncVersion: syncVersion ?? this.syncVersion,
  );
  LocalHealthRecord copyWithCompanion(LocalHealthRecordsCompanion data) {
    return LocalHealthRecord(
      id: data.id.present ? data.id.value : this.id,
      patientId: data.patientId.present ? data.patientId.value : this.patientId,
      doctorId: data.doctorId.present ? data.doctorId.value : this.doctorId,
      appointmentId: data.appointmentId.present
          ? data.appointmentId.value
          : this.appointmentId,
      recordType: data.recordType.present
          ? data.recordType.value
          : this.recordType,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      attachmentUrl: data.attachmentUrl.present
          ? data.attachmentUrl.value
          : this.attachmentUrl,
      metadata: data.metadata.present ? data.metadata.value : this.metadata,
      recordDate: data.recordDate.present
          ? data.recordDate.value
          : this.recordDate,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      lastSyncAt: data.lastSyncAt.present
          ? data.lastSyncAt.value
          : this.lastSyncAt,
      pendingDelete: data.pendingDelete.present
          ? data.pendingDelete.value
          : this.pendingDelete,
      syncVersion: data.syncVersion.present
          ? data.syncVersion.value
          : this.syncVersion,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalHealthRecord(')
          ..write('id: $id, ')
          ..write('patientId: $patientId, ')
          ..write('doctorId: $doctorId, ')
          ..write('appointmentId: $appointmentId, ')
          ..write('recordType: $recordType, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('attachmentUrl: $attachmentUrl, ')
          ..write('metadata: $metadata, ')
          ..write('recordDate: $recordDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('lastSyncAt: $lastSyncAt, ')
          ..write('pendingDelete: $pendingDelete, ')
          ..write('syncVersion: $syncVersion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    patientId,
    doctorId,
    appointmentId,
    recordType,
    title,
    description,
    attachmentUrl,
    metadata,
    recordDate,
    createdAt,
    updatedAt,
    isSynced,
    lastSyncAt,
    pendingDelete,
    syncVersion,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalHealthRecord &&
          other.id == this.id &&
          other.patientId == this.patientId &&
          other.doctorId == this.doctorId &&
          other.appointmentId == this.appointmentId &&
          other.recordType == this.recordType &&
          other.title == this.title &&
          other.description == this.description &&
          other.attachmentUrl == this.attachmentUrl &&
          other.metadata == this.metadata &&
          other.recordDate == this.recordDate &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.isSynced == this.isSynced &&
          other.lastSyncAt == this.lastSyncAt &&
          other.pendingDelete == this.pendingDelete &&
          other.syncVersion == this.syncVersion);
}

class LocalHealthRecordsCompanion extends UpdateCompanion<LocalHealthRecord> {
  final Value<String> id;
  final Value<String> patientId;
  final Value<String?> doctorId;
  final Value<String?> appointmentId;
  final Value<String> recordType;
  final Value<String> title;
  final Value<String?> description;
  final Value<String?> attachmentUrl;
  final Value<String> metadata;
  final Value<DateTime> recordDate;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> isSynced;
  final Value<DateTime?> lastSyncAt;
  final Value<bool> pendingDelete;
  final Value<String> syncVersion;
  final Value<int> rowid;
  const LocalHealthRecordsCompanion({
    this.id = const Value.absent(),
    this.patientId = const Value.absent(),
    this.doctorId = const Value.absent(),
    this.appointmentId = const Value.absent(),
    this.recordType = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.attachmentUrl = const Value.absent(),
    this.metadata = const Value.absent(),
    this.recordDate = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.lastSyncAt = const Value.absent(),
    this.pendingDelete = const Value.absent(),
    this.syncVersion = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalHealthRecordsCompanion.insert({
    required String id,
    required String patientId,
    this.doctorId = const Value.absent(),
    this.appointmentId = const Value.absent(),
    required String recordType,
    required String title,
    this.description = const Value.absent(),
    this.attachmentUrl = const Value.absent(),
    this.metadata = const Value.absent(),
    required DateTime recordDate,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.isSynced = const Value.absent(),
    this.lastSyncAt = const Value.absent(),
    this.pendingDelete = const Value.absent(),
    this.syncVersion = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       patientId = Value(patientId),
       recordType = Value(recordType),
       title = Value(title),
       recordDate = Value(recordDate),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<LocalHealthRecord> custom({
    Expression<String>? id,
    Expression<String>? patientId,
    Expression<String>? doctorId,
    Expression<String>? appointmentId,
    Expression<String>? recordType,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? attachmentUrl,
    Expression<String>? metadata,
    Expression<DateTime>? recordDate,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isSynced,
    Expression<DateTime>? lastSyncAt,
    Expression<bool>? pendingDelete,
    Expression<String>? syncVersion,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (patientId != null) 'patient_id': patientId,
      if (doctorId != null) 'doctor_id': doctorId,
      if (appointmentId != null) 'appointment_id': appointmentId,
      if (recordType != null) 'record_type': recordType,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (attachmentUrl != null) 'attachment_url': attachmentUrl,
      if (metadata != null) 'metadata': metadata,
      if (recordDate != null) 'record_date': recordDate,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isSynced != null) 'is_synced': isSynced,
      if (lastSyncAt != null) 'last_sync_at': lastSyncAt,
      if (pendingDelete != null) 'pending_delete': pendingDelete,
      if (syncVersion != null) 'sync_version': syncVersion,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalHealthRecordsCompanion copyWith({
    Value<String>? id,
    Value<String>? patientId,
    Value<String?>? doctorId,
    Value<String?>? appointmentId,
    Value<String>? recordType,
    Value<String>? title,
    Value<String?>? description,
    Value<String?>? attachmentUrl,
    Value<String>? metadata,
    Value<DateTime>? recordDate,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<bool>? isSynced,
    Value<DateTime?>? lastSyncAt,
    Value<bool>? pendingDelete,
    Value<String>? syncVersion,
    Value<int>? rowid,
  }) {
    return LocalHealthRecordsCompanion(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      doctorId: doctorId ?? this.doctorId,
      appointmentId: appointmentId ?? this.appointmentId,
      recordType: recordType ?? this.recordType,
      title: title ?? this.title,
      description: description ?? this.description,
      attachmentUrl: attachmentUrl ?? this.attachmentUrl,
      metadata: metadata ?? this.metadata,
      recordDate: recordDate ?? this.recordDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
      pendingDelete: pendingDelete ?? this.pendingDelete,
      syncVersion: syncVersion ?? this.syncVersion,
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
    if (doctorId.present) {
      map['doctor_id'] = Variable<String>(doctorId.value);
    }
    if (appointmentId.present) {
      map['appointment_id'] = Variable<String>(appointmentId.value);
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
    if (attachmentUrl.present) {
      map['attachment_url'] = Variable<String>(attachmentUrl.value);
    }
    if (metadata.present) {
      map['metadata'] = Variable<String>(metadata.value);
    }
    if (recordDate.present) {
      map['record_date'] = Variable<DateTime>(recordDate.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (lastSyncAt.present) {
      map['last_sync_at'] = Variable<DateTime>(lastSyncAt.value);
    }
    if (pendingDelete.present) {
      map['pending_delete'] = Variable<bool>(pendingDelete.value);
    }
    if (syncVersion.present) {
      map['sync_version'] = Variable<String>(syncVersion.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalHealthRecordsCompanion(')
          ..write('id: $id, ')
          ..write('patientId: $patientId, ')
          ..write('doctorId: $doctorId, ')
          ..write('appointmentId: $appointmentId, ')
          ..write('recordType: $recordType, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('attachmentUrl: $attachmentUrl, ')
          ..write('metadata: $metadata, ')
          ..write('recordDate: $recordDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('lastSyncAt: $lastSyncAt, ')
          ..write('pendingDelete: $pendingDelete, ')
          ..write('syncVersion: $syncVersion, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncOperationsTable extends SyncOperations
    with TableInfo<$SyncOperationsTable, SyncOperation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncOperationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _tableNameColumnMeta = const VerificationMeta(
    'tableNameColumn',
  );
  @override
  late final GeneratedColumn<String> tableNameColumn = GeneratedColumn<String>(
    'table_name',
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
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isCompletedMeta = const VerificationMeta(
    'isCompleted',
  );
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
    'is_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
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
  static const VerificationMeta _lastRetryAtMeta = const VerificationMeta(
    'lastRetryAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastRetryAt = GeneratedColumn<DateTime>(
    'last_retry_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _errorMessageMeta = const VerificationMeta(
    'errorMessage',
  );
  @override
  late final GeneratedColumn<String> errorMessage = GeneratedColumn<String>(
    'error_message',
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    tableNameColumn,
    recordId,
    operation,
    data,
    isCompleted,
    retryCount,
    lastRetryAt,
    errorMessage,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_operations';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncOperation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('table_name')) {
      context.handle(
        _tableNameColumnMeta,
        tableNameColumn.isAcceptableOrUnknown(
          data['table_name']!,
          _tableNameColumnMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_tableNameColumnMeta);
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
    }
    if (data.containsKey('is_completed')) {
      context.handle(
        _isCompletedMeta,
        isCompleted.isAcceptableOrUnknown(
          data['is_completed']!,
          _isCompletedMeta,
        ),
      );
    }
    if (data.containsKey('retry_count')) {
      context.handle(
        _retryCountMeta,
        retryCount.isAcceptableOrUnknown(data['retry_count']!, _retryCountMeta),
      );
    }
    if (data.containsKey('last_retry_at')) {
      context.handle(
        _lastRetryAtMeta,
        lastRetryAt.isAcceptableOrUnknown(
          data['last_retry_at']!,
          _lastRetryAtMeta,
        ),
      );
    }
    if (data.containsKey('error_message')) {
      context.handle(
        _errorMessageMeta,
        errorMessage.isAcceptableOrUnknown(
          data['error_message']!,
          _errorMessageMeta,
        ),
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
  SyncOperation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncOperation(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      tableNameColumn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}table_name'],
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
      ),
      isCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_completed'],
      )!,
      retryCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}retry_count'],
      )!,
      lastRetryAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_retry_at'],
      ),
      errorMessage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}error_message'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $SyncOperationsTable createAlias(String alias) {
    return $SyncOperationsTable(attachedDatabase, alias);
  }
}

class SyncOperation extends DataClass implements Insertable<SyncOperation> {
  final int id;
  final String tableNameColumn;
  final String recordId;
  final String operation;
  final String? data;
  final bool isCompleted;
  final int retryCount;
  final DateTime? lastRetryAt;
  final String? errorMessage;
  final DateTime createdAt;
  const SyncOperation({
    required this.id,
    required this.tableNameColumn,
    required this.recordId,
    required this.operation,
    this.data,
    required this.isCompleted,
    required this.retryCount,
    this.lastRetryAt,
    this.errorMessage,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['table_name'] = Variable<String>(tableNameColumn);
    map['record_id'] = Variable<String>(recordId);
    map['operation'] = Variable<String>(operation);
    if (!nullToAbsent || data != null) {
      map['data'] = Variable<String>(data);
    }
    map['is_completed'] = Variable<bool>(isCompleted);
    map['retry_count'] = Variable<int>(retryCount);
    if (!nullToAbsent || lastRetryAt != null) {
      map['last_retry_at'] = Variable<DateTime>(lastRetryAt);
    }
    if (!nullToAbsent || errorMessage != null) {
      map['error_message'] = Variable<String>(errorMessage);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SyncOperationsCompanion toCompanion(bool nullToAbsent) {
    return SyncOperationsCompanion(
      id: Value(id),
      tableNameColumn: Value(tableNameColumn),
      recordId: Value(recordId),
      operation: Value(operation),
      data: data == null && nullToAbsent ? const Value.absent() : Value(data),
      isCompleted: Value(isCompleted),
      retryCount: Value(retryCount),
      lastRetryAt: lastRetryAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastRetryAt),
      errorMessage: errorMessage == null && nullToAbsent
          ? const Value.absent()
          : Value(errorMessage),
      createdAt: Value(createdAt),
    );
  }

  factory SyncOperation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncOperation(
      id: serializer.fromJson<int>(json['id']),
      tableNameColumn: serializer.fromJson<String>(json['tableNameColumn']),
      recordId: serializer.fromJson<String>(json['recordId']),
      operation: serializer.fromJson<String>(json['operation']),
      data: serializer.fromJson<String?>(json['data']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
      retryCount: serializer.fromJson<int>(json['retryCount']),
      lastRetryAt: serializer.fromJson<DateTime?>(json['lastRetryAt']),
      errorMessage: serializer.fromJson<String?>(json['errorMessage']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'tableNameColumn': serializer.toJson<String>(tableNameColumn),
      'recordId': serializer.toJson<String>(recordId),
      'operation': serializer.toJson<String>(operation),
      'data': serializer.toJson<String?>(data),
      'isCompleted': serializer.toJson<bool>(isCompleted),
      'retryCount': serializer.toJson<int>(retryCount),
      'lastRetryAt': serializer.toJson<DateTime?>(lastRetryAt),
      'errorMessage': serializer.toJson<String?>(errorMessage),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SyncOperation copyWith({
    int? id,
    String? tableNameColumn,
    String? recordId,
    String? operation,
    Value<String?> data = const Value.absent(),
    bool? isCompleted,
    int? retryCount,
    Value<DateTime?> lastRetryAt = const Value.absent(),
    Value<String?> errorMessage = const Value.absent(),
    DateTime? createdAt,
  }) => SyncOperation(
    id: id ?? this.id,
    tableNameColumn: tableNameColumn ?? this.tableNameColumn,
    recordId: recordId ?? this.recordId,
    operation: operation ?? this.operation,
    data: data.present ? data.value : this.data,
    isCompleted: isCompleted ?? this.isCompleted,
    retryCount: retryCount ?? this.retryCount,
    lastRetryAt: lastRetryAt.present ? lastRetryAt.value : this.lastRetryAt,
    errorMessage: errorMessage.present ? errorMessage.value : this.errorMessage,
    createdAt: createdAt ?? this.createdAt,
  );
  SyncOperation copyWithCompanion(SyncOperationsCompanion data) {
    return SyncOperation(
      id: data.id.present ? data.id.value : this.id,
      tableNameColumn: data.tableNameColumn.present
          ? data.tableNameColumn.value
          : this.tableNameColumn,
      recordId: data.recordId.present ? data.recordId.value : this.recordId,
      operation: data.operation.present ? data.operation.value : this.operation,
      data: data.data.present ? data.data.value : this.data,
      isCompleted: data.isCompleted.present
          ? data.isCompleted.value
          : this.isCompleted,
      retryCount: data.retryCount.present
          ? data.retryCount.value
          : this.retryCount,
      lastRetryAt: data.lastRetryAt.present
          ? data.lastRetryAt.value
          : this.lastRetryAt,
      errorMessage: data.errorMessage.present
          ? data.errorMessage.value
          : this.errorMessage,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncOperation(')
          ..write('id: $id, ')
          ..write('tableNameColumn: $tableNameColumn, ')
          ..write('recordId: $recordId, ')
          ..write('operation: $operation, ')
          ..write('data: $data, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('retryCount: $retryCount, ')
          ..write('lastRetryAt: $lastRetryAt, ')
          ..write('errorMessage: $errorMessage, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    tableNameColumn,
    recordId,
    operation,
    data,
    isCompleted,
    retryCount,
    lastRetryAt,
    errorMessage,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncOperation &&
          other.id == this.id &&
          other.tableNameColumn == this.tableNameColumn &&
          other.recordId == this.recordId &&
          other.operation == this.operation &&
          other.data == this.data &&
          other.isCompleted == this.isCompleted &&
          other.retryCount == this.retryCount &&
          other.lastRetryAt == this.lastRetryAt &&
          other.errorMessage == this.errorMessage &&
          other.createdAt == this.createdAt);
}

class SyncOperationsCompanion extends UpdateCompanion<SyncOperation> {
  final Value<int> id;
  final Value<String> tableNameColumn;
  final Value<String> recordId;
  final Value<String> operation;
  final Value<String?> data;
  final Value<bool> isCompleted;
  final Value<int> retryCount;
  final Value<DateTime?> lastRetryAt;
  final Value<String?> errorMessage;
  final Value<DateTime> createdAt;
  const SyncOperationsCompanion({
    this.id = const Value.absent(),
    this.tableNameColumn = const Value.absent(),
    this.recordId = const Value.absent(),
    this.operation = const Value.absent(),
    this.data = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.lastRetryAt = const Value.absent(),
    this.errorMessage = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SyncOperationsCompanion.insert({
    this.id = const Value.absent(),
    required String tableNameColumn,
    required String recordId,
    required String operation,
    this.data = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.lastRetryAt = const Value.absent(),
    this.errorMessage = const Value.absent(),
    required DateTime createdAt,
  }) : tableNameColumn = Value(tableNameColumn),
       recordId = Value(recordId),
       operation = Value(operation),
       createdAt = Value(createdAt);
  static Insertable<SyncOperation> custom({
    Expression<int>? id,
    Expression<String>? tableNameColumn,
    Expression<String>? recordId,
    Expression<String>? operation,
    Expression<String>? data,
    Expression<bool>? isCompleted,
    Expression<int>? retryCount,
    Expression<DateTime>? lastRetryAt,
    Expression<String>? errorMessage,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tableNameColumn != null) 'table_name': tableNameColumn,
      if (recordId != null) 'record_id': recordId,
      if (operation != null) 'operation': operation,
      if (data != null) 'data': data,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (retryCount != null) 'retry_count': retryCount,
      if (lastRetryAt != null) 'last_retry_at': lastRetryAt,
      if (errorMessage != null) 'error_message': errorMessage,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SyncOperationsCompanion copyWith({
    Value<int>? id,
    Value<String>? tableNameColumn,
    Value<String>? recordId,
    Value<String>? operation,
    Value<String?>? data,
    Value<bool>? isCompleted,
    Value<int>? retryCount,
    Value<DateTime?>? lastRetryAt,
    Value<String?>? errorMessage,
    Value<DateTime>? createdAt,
  }) {
    return SyncOperationsCompanion(
      id: id ?? this.id,
      tableNameColumn: tableNameColumn ?? this.tableNameColumn,
      recordId: recordId ?? this.recordId,
      operation: operation ?? this.operation,
      data: data ?? this.data,
      isCompleted: isCompleted ?? this.isCompleted,
      retryCount: retryCount ?? this.retryCount,
      lastRetryAt: lastRetryAt ?? this.lastRetryAt,
      errorMessage: errorMessage ?? this.errorMessage,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (tableNameColumn.present) {
      map['table_name'] = Variable<String>(tableNameColumn.value);
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
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (retryCount.present) {
      map['retry_count'] = Variable<int>(retryCount.value);
    }
    if (lastRetryAt.present) {
      map['last_retry_at'] = Variable<DateTime>(lastRetryAt.value);
    }
    if (errorMessage.present) {
      map['error_message'] = Variable<String>(errorMessage.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncOperationsCompanion(')
          ..write('id: $id, ')
          ..write('tableNameColumn: $tableNameColumn, ')
          ..write('recordId: $recordId, ')
          ..write('operation: $operation, ')
          ..write('data: $data, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('retryCount: $retryCount, ')
          ..write('lastRetryAt: $lastRetryAt, ')
          ..write('errorMessage: $errorMessage, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $LocalAppSettingsTable extends LocalAppSettings
    with TableInfo<$LocalAppSettingsTable, LocalAppSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalAppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
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
  @override
  List<GeneratedColumn> get $columns => [key, value, updatedAt, isSynced];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalAppSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  LocalAppSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalAppSetting(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
    );
  }

  @override
  $LocalAppSettingsTable createAlias(String alias) {
    return $LocalAppSettingsTable(attachedDatabase, alias);
  }
}

class LocalAppSetting extends DataClass implements Insertable<LocalAppSetting> {
  final String key;
  final String value;
  final DateTime updatedAt;
  final bool isSynced;
  const LocalAppSetting({
    required this.key,
    required this.value,
    required this.updatedAt,
    required this.isSynced,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['is_synced'] = Variable<bool>(isSynced);
    return map;
  }

  LocalAppSettingsCompanion toCompanion(bool nullToAbsent) {
    return LocalAppSettingsCompanion(
      key: Value(key),
      value: Value(value),
      updatedAt: Value(updatedAt),
      isSynced: Value(isSynced),
    );
  }

  factory LocalAppSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalAppSetting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'isSynced': serializer.toJson<bool>(isSynced),
    };
  }

  LocalAppSetting copyWith({
    String? key,
    String? value,
    DateTime? updatedAt,
    bool? isSynced,
  }) => LocalAppSetting(
    key: key ?? this.key,
    value: value ?? this.value,
    updatedAt: updatedAt ?? this.updatedAt,
    isSynced: isSynced ?? this.isSynced,
  );
  LocalAppSetting copyWithCompanion(LocalAppSettingsCompanion data) {
    return LocalAppSetting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalAppSetting(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isSynced: $isSynced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value, updatedAt, isSynced);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalAppSetting &&
          other.key == this.key &&
          other.value == this.value &&
          other.updatedAt == this.updatedAt &&
          other.isSynced == this.isSynced);
}

class LocalAppSettingsCompanion extends UpdateCompanion<LocalAppSetting> {
  final Value<String> key;
  final Value<String> value;
  final Value<DateTime> updatedAt;
  final Value<bool> isSynced;
  final Value<int> rowid;
  const LocalAppSettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalAppSettingsCompanion.insert({
    required String key,
    required String value,
    required DateTime updatedAt,
    this.isSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value),
       updatedAt = Value(updatedAt);
  static Insertable<LocalAppSetting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isSynced,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isSynced != null) 'is_synced': isSynced,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalAppSettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<DateTime>? updatedAt,
    Value<bool>? isSynced,
    Value<int>? rowid,
  }) {
    return LocalAppSettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalAppSettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalTodosTable extends LocalTodos
    with TableInfo<$LocalTodosTable, LocalTodo> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalTodosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
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
  static const VerificationMeta _isCompletedMeta = const VerificationMeta(
    'isCompleted',
  );
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
    'is_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
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
  static const VerificationMeta _dueDateMeta = const VerificationMeta(
    'dueDate',
  );
  @override
  late final GeneratedColumn<DateTime> dueDate = GeneratedColumn<DateTime>(
    'due_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
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
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
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
  static const VerificationMeta _lastSyncAtMeta = const VerificationMeta(
    'lastSyncAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastSyncAt = GeneratedColumn<DateTime>(
    'last_sync_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pendingDeleteMeta = const VerificationMeta(
    'pendingDelete',
  );
  @override
  late final GeneratedColumn<bool> pendingDelete = GeneratedColumn<bool>(
    'pending_delete',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("pending_delete" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _syncVersionMeta = const VerificationMeta(
    'syncVersion',
  );
  @override
  late final GeneratedColumn<String> syncVersion = GeneratedColumn<String>(
    'sync_version',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('1'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    description,
    isCompleted,
    priority,
    dueDate,
    completedAt,
    createdAt,
    updatedAt,
    isSynced,
    lastSyncAt,
    pendingDelete,
    syncVersion,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_todos';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalTodo> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
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
    if (data.containsKey('is_completed')) {
      context.handle(
        _isCompletedMeta,
        isCompleted.isAcceptableOrUnknown(
          data['is_completed']!,
          _isCompletedMeta,
        ),
      );
    }
    if (data.containsKey('priority')) {
      context.handle(
        _priorityMeta,
        priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta),
      );
    }
    if (data.containsKey('due_date')) {
      context.handle(
        _dueDateMeta,
        dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta),
      );
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
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
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    if (data.containsKey('last_sync_at')) {
      context.handle(
        _lastSyncAtMeta,
        lastSyncAt.isAcceptableOrUnknown(
          data['last_sync_at']!,
          _lastSyncAtMeta,
        ),
      );
    }
    if (data.containsKey('pending_delete')) {
      context.handle(
        _pendingDeleteMeta,
        pendingDelete.isAcceptableOrUnknown(
          data['pending_delete']!,
          _pendingDeleteMeta,
        ),
      );
    }
    if (data.containsKey('sync_version')) {
      context.handle(
        _syncVersionMeta,
        syncVersion.isAcceptableOrUnknown(
          data['sync_version']!,
          _syncVersionMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalTodo map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalTodo(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      isCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_completed'],
      )!,
      priority: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}priority'],
      )!,
      dueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due_date'],
      ),
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
      lastSyncAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_sync_at'],
      ),
      pendingDelete: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}pending_delete'],
      )!,
      syncVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_version'],
      )!,
    );
  }

  @override
  $LocalTodosTable createAlias(String alias) {
    return $LocalTodosTable(attachedDatabase, alias);
  }
}

class LocalTodo extends DataClass implements Insertable<LocalTodo> {
  final String id;
  final String title;
  final String? description;
  final bool isCompleted;
  final int priority;
  final DateTime? dueDate;
  final DateTime? completedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isSynced;
  final DateTime? lastSyncAt;
  final bool pendingDelete;
  final String syncVersion;
  const LocalTodo({
    required this.id,
    required this.title,
    this.description,
    required this.isCompleted,
    required this.priority,
    this.dueDate,
    this.completedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.isSynced,
    this.lastSyncAt,
    required this.pendingDelete,
    required this.syncVersion,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['is_completed'] = Variable<bool>(isCompleted);
    map['priority'] = Variable<int>(priority);
    if (!nullToAbsent || dueDate != null) {
      map['due_date'] = Variable<DateTime>(dueDate);
    }
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['is_synced'] = Variable<bool>(isSynced);
    if (!nullToAbsent || lastSyncAt != null) {
      map['last_sync_at'] = Variable<DateTime>(lastSyncAt);
    }
    map['pending_delete'] = Variable<bool>(pendingDelete);
    map['sync_version'] = Variable<String>(syncVersion);
    return map;
  }

  LocalTodosCompanion toCompanion(bool nullToAbsent) {
    return LocalTodosCompanion(
      id: Value(id),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      isCompleted: Value(isCompleted),
      priority: Value(priority),
      dueDate: dueDate == null && nullToAbsent
          ? const Value.absent()
          : Value(dueDate),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      isSynced: Value(isSynced),
      lastSyncAt: lastSyncAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncAt),
      pendingDelete: Value(pendingDelete),
      syncVersion: Value(syncVersion),
    );
  }

  factory LocalTodo.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalTodo(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
      priority: serializer.fromJson<int>(json['priority']),
      dueDate: serializer.fromJson<DateTime?>(json['dueDate']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      lastSyncAt: serializer.fromJson<DateTime?>(json['lastSyncAt']),
      pendingDelete: serializer.fromJson<bool>(json['pendingDelete']),
      syncVersion: serializer.fromJson<String>(json['syncVersion']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'isCompleted': serializer.toJson<bool>(isCompleted),
      'priority': serializer.toJson<int>(priority),
      'dueDate': serializer.toJson<DateTime?>(dueDate),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'isSynced': serializer.toJson<bool>(isSynced),
      'lastSyncAt': serializer.toJson<DateTime?>(lastSyncAt),
      'pendingDelete': serializer.toJson<bool>(pendingDelete),
      'syncVersion': serializer.toJson<String>(syncVersion),
    };
  }

  LocalTodo copyWith({
    String? id,
    String? title,
    Value<String?> description = const Value.absent(),
    bool? isCompleted,
    int? priority,
    Value<DateTime?> dueDate = const Value.absent(),
    Value<DateTime?> completedAt = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isSynced,
    Value<DateTime?> lastSyncAt = const Value.absent(),
    bool? pendingDelete,
    String? syncVersion,
  }) => LocalTodo(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description.present ? description.value : this.description,
    isCompleted: isCompleted ?? this.isCompleted,
    priority: priority ?? this.priority,
    dueDate: dueDate.present ? dueDate.value : this.dueDate,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    isSynced: isSynced ?? this.isSynced,
    lastSyncAt: lastSyncAt.present ? lastSyncAt.value : this.lastSyncAt,
    pendingDelete: pendingDelete ?? this.pendingDelete,
    syncVersion: syncVersion ?? this.syncVersion,
  );
  LocalTodo copyWithCompanion(LocalTodosCompanion data) {
    return LocalTodo(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      isCompleted: data.isCompleted.present
          ? data.isCompleted.value
          : this.isCompleted,
      priority: data.priority.present ? data.priority.value : this.priority,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      lastSyncAt: data.lastSyncAt.present
          ? data.lastSyncAt.value
          : this.lastSyncAt,
      pendingDelete: data.pendingDelete.present
          ? data.pendingDelete.value
          : this.pendingDelete,
      syncVersion: data.syncVersion.present
          ? data.syncVersion.value
          : this.syncVersion,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalTodo(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('priority: $priority, ')
          ..write('dueDate: $dueDate, ')
          ..write('completedAt: $completedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('lastSyncAt: $lastSyncAt, ')
          ..write('pendingDelete: $pendingDelete, ')
          ..write('syncVersion: $syncVersion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    description,
    isCompleted,
    priority,
    dueDate,
    completedAt,
    createdAt,
    updatedAt,
    isSynced,
    lastSyncAt,
    pendingDelete,
    syncVersion,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalTodo &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description &&
          other.isCompleted == this.isCompleted &&
          other.priority == this.priority &&
          other.dueDate == this.dueDate &&
          other.completedAt == this.completedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.isSynced == this.isSynced &&
          other.lastSyncAt == this.lastSyncAt &&
          other.pendingDelete == this.pendingDelete &&
          other.syncVersion == this.syncVersion);
}

class LocalTodosCompanion extends UpdateCompanion<LocalTodo> {
  final Value<String> id;
  final Value<String> title;
  final Value<String?> description;
  final Value<bool> isCompleted;
  final Value<int> priority;
  final Value<DateTime?> dueDate;
  final Value<DateTime?> completedAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> isSynced;
  final Value<DateTime?> lastSyncAt;
  final Value<bool> pendingDelete;
  final Value<String> syncVersion;
  final Value<int> rowid;
  const LocalTodosCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.priority = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.lastSyncAt = const Value.absent(),
    this.pendingDelete = const Value.absent(),
    this.syncVersion = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalTodosCompanion.insert({
    required String id,
    required String title,
    this.description = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.priority = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.completedAt = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.isSynced = const Value.absent(),
    this.lastSyncAt = const Value.absent(),
    this.pendingDelete = const Value.absent(),
    this.syncVersion = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<LocalTodo> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? description,
    Expression<bool>? isCompleted,
    Expression<int>? priority,
    Expression<DateTime>? dueDate,
    Expression<DateTime>? completedAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isSynced,
    Expression<DateTime>? lastSyncAt,
    Expression<bool>? pendingDelete,
    Expression<String>? syncVersion,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (priority != null) 'priority': priority,
      if (dueDate != null) 'due_date': dueDate,
      if (completedAt != null) 'completed_at': completedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isSynced != null) 'is_synced': isSynced,
      if (lastSyncAt != null) 'last_sync_at': lastSyncAt,
      if (pendingDelete != null) 'pending_delete': pendingDelete,
      if (syncVersion != null) 'sync_version': syncVersion,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalTodosCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String?>? description,
    Value<bool>? isCompleted,
    Value<int>? priority,
    Value<DateTime?>? dueDate,
    Value<DateTime?>? completedAt,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<bool>? isSynced,
    Value<DateTime?>? lastSyncAt,
    Value<bool>? pendingDelete,
    Value<String>? syncVersion,
    Value<int>? rowid,
  }) {
    return LocalTodosCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
      completedAt: completedAt ?? this.completedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
      pendingDelete: pendingDelete ?? this.pendingDelete,
      syncVersion: syncVersion ?? this.syncVersion,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (priority.present) {
      map['priority'] = Variable<int>(priority.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<DateTime>(dueDate.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (lastSyncAt.present) {
      map['last_sync_at'] = Variable<DateTime>(lastSyncAt.value);
    }
    if (pendingDelete.present) {
      map['pending_delete'] = Variable<bool>(pendingDelete.value);
    }
    if (syncVersion.present) {
      map['sync_version'] = Variable<String>(syncVersion.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalTodosCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('priority: $priority, ')
          ..write('dueDate: $dueDate, ')
          ..write('completedAt: $completedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('lastSyncAt: $lastSyncAt, ')
          ..write('pendingDelete: $pendingDelete, ')
          ..write('syncVersion: $syncVersion, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$LocalDatabase extends GeneratedDatabase {
  _$LocalDatabase(QueryExecutor e) : super(e);
  $LocalDatabaseManager get managers => $LocalDatabaseManager(this);
  late final $LocalPatientProfilesTable localPatientProfiles =
      $LocalPatientProfilesTable(this);
  late final $LocalDoctorsTable localDoctors = $LocalDoctorsTable(this);
  late final $LocalAppointmentsTable localAppointments =
      $LocalAppointmentsTable(this);
  late final $LocalHealthRecordsTable localHealthRecords =
      $LocalHealthRecordsTable(this);
  late final $SyncOperationsTable syncOperations = $SyncOperationsTable(this);
  late final $LocalAppSettingsTable localAppSettings = $LocalAppSettingsTable(
    this,
  );
  late final $LocalTodosTable localTodos = $LocalTodosTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    localPatientProfiles,
    localDoctors,
    localAppointments,
    localHealthRecords,
    syncOperations,
    localAppSettings,
    localTodos,
  ];
}

typedef $$LocalPatientProfilesTableCreateCompanionBuilder =
    LocalPatientProfilesCompanion Function({
      required String id,
      required String fullName,
      required String email,
      Value<String?> phoneNumber,
      Value<DateTime?> dateOfBirth,
      Value<String?> gender,
      Value<String?> bloodGroup,
      Value<String?> address,
      Value<String?> emergencyContact,
      Value<String?> emergencyContactPhone,
      Value<String?> profilePhotoUrl,
      Value<String> allergies,
      Value<String> medications,
      Value<String> medicalHistory,
      Value<DateTime?> lastVisit,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<bool> isSynced,
      Value<DateTime?> lastSyncAt,
      Value<bool> pendingDelete,
      Value<String> syncVersion,
      Value<int> rowid,
    });
typedef $$LocalPatientProfilesTableUpdateCompanionBuilder =
    LocalPatientProfilesCompanion Function({
      Value<String> id,
      Value<String> fullName,
      Value<String> email,
      Value<String?> phoneNumber,
      Value<DateTime?> dateOfBirth,
      Value<String?> gender,
      Value<String?> bloodGroup,
      Value<String?> address,
      Value<String?> emergencyContact,
      Value<String?> emergencyContactPhone,
      Value<String?> profilePhotoUrl,
      Value<String> allergies,
      Value<String> medications,
      Value<String> medicalHistory,
      Value<DateTime?> lastVisit,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<bool> isSynced,
      Value<DateTime?> lastSyncAt,
      Value<bool> pendingDelete,
      Value<String> syncVersion,
      Value<int> rowid,
    });

class $$LocalPatientProfilesTableFilterComposer
    extends Composer<_$LocalDatabase, $LocalPatientProfilesTable> {
  $$LocalPatientProfilesTableFilterComposer({
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

  ColumnFilters<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
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

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get emergencyContact => $composableBuilder(
    column: $table.emergencyContact,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get emergencyContactPhone => $composableBuilder(
    column: $table.emergencyContactPhone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get profilePhotoUrl => $composableBuilder(
    column: $table.profilePhotoUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get allergies => $composableBuilder(
    column: $table.allergies,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get medications => $composableBuilder(
    column: $table.medications,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get medicalHistory => $composableBuilder(
    column: $table.medicalHistory,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastVisit => $composableBuilder(
    column: $table.lastVisit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get pendingDelete => $composableBuilder(
    column: $table.pendingDelete,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncVersion => $composableBuilder(
    column: $table.syncVersion,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalPatientProfilesTableOrderingComposer
    extends Composer<_$LocalDatabase, $LocalPatientProfilesTable> {
  $$LocalPatientProfilesTableOrderingComposer({
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

  ColumnOrderings<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
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

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get emergencyContact => $composableBuilder(
    column: $table.emergencyContact,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get emergencyContactPhone => $composableBuilder(
    column: $table.emergencyContactPhone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get profilePhotoUrl => $composableBuilder(
    column: $table.profilePhotoUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get allergies => $composableBuilder(
    column: $table.allergies,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get medications => $composableBuilder(
    column: $table.medications,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get medicalHistory => $composableBuilder(
    column: $table.medicalHistory,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastVisit => $composableBuilder(
    column: $table.lastVisit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get pendingDelete => $composableBuilder(
    column: $table.pendingDelete,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncVersion => $composableBuilder(
    column: $table.syncVersion,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalPatientProfilesTableAnnotationComposer
    extends Composer<_$LocalDatabase, $LocalPatientProfilesTable> {
  $$LocalPatientProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get fullName =>
      $composableBuilder(column: $table.fullName, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
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

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get emergencyContact => $composableBuilder(
    column: $table.emergencyContact,
    builder: (column) => column,
  );

  GeneratedColumn<String> get emergencyContactPhone => $composableBuilder(
    column: $table.emergencyContactPhone,
    builder: (column) => column,
  );

  GeneratedColumn<String> get profilePhotoUrl => $composableBuilder(
    column: $table.profilePhotoUrl,
    builder: (column) => column,
  );

  GeneratedColumn<String> get allergies =>
      $composableBuilder(column: $table.allergies, builder: (column) => column);

  GeneratedColumn<String> get medications => $composableBuilder(
    column: $table.medications,
    builder: (column) => column,
  );

  GeneratedColumn<String> get medicalHistory => $composableBuilder(
    column: $table.medicalHistory,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastVisit =>
      $composableBuilder(column: $table.lastVisit, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get pendingDelete => $composableBuilder(
    column: $table.pendingDelete,
    builder: (column) => column,
  );

  GeneratedColumn<String> get syncVersion => $composableBuilder(
    column: $table.syncVersion,
    builder: (column) => column,
  );
}

class $$LocalPatientProfilesTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $LocalPatientProfilesTable,
          LocalPatientProfile,
          $$LocalPatientProfilesTableFilterComposer,
          $$LocalPatientProfilesTableOrderingComposer,
          $$LocalPatientProfilesTableAnnotationComposer,
          $$LocalPatientProfilesTableCreateCompanionBuilder,
          $$LocalPatientProfilesTableUpdateCompanionBuilder,
          (
            LocalPatientProfile,
            BaseReferences<
              _$LocalDatabase,
              $LocalPatientProfilesTable,
              LocalPatientProfile
            >,
          ),
          LocalPatientProfile,
          PrefetchHooks Function()
        > {
  $$LocalPatientProfilesTableTableManager(
    _$LocalDatabase db,
    $LocalPatientProfilesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalPatientProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalPatientProfilesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$LocalPatientProfilesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> fullName = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String?> phoneNumber = const Value.absent(),
                Value<DateTime?> dateOfBirth = const Value.absent(),
                Value<String?> gender = const Value.absent(),
                Value<String?> bloodGroup = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<String?> emergencyContact = const Value.absent(),
                Value<String?> emergencyContactPhone = const Value.absent(),
                Value<String?> profilePhotoUrl = const Value.absent(),
                Value<String> allergies = const Value.absent(),
                Value<String> medications = const Value.absent(),
                Value<String> medicalHistory = const Value.absent(),
                Value<DateTime?> lastVisit = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<DateTime?> lastSyncAt = const Value.absent(),
                Value<bool> pendingDelete = const Value.absent(),
                Value<String> syncVersion = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalPatientProfilesCompanion(
                id: id,
                fullName: fullName,
                email: email,
                phoneNumber: phoneNumber,
                dateOfBirth: dateOfBirth,
                gender: gender,
                bloodGroup: bloodGroup,
                address: address,
                emergencyContact: emergencyContact,
                emergencyContactPhone: emergencyContactPhone,
                profilePhotoUrl: profilePhotoUrl,
                allergies: allergies,
                medications: medications,
                medicalHistory: medicalHistory,
                lastVisit: lastVisit,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isSynced: isSynced,
                lastSyncAt: lastSyncAt,
                pendingDelete: pendingDelete,
                syncVersion: syncVersion,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String fullName,
                required String email,
                Value<String?> phoneNumber = const Value.absent(),
                Value<DateTime?> dateOfBirth = const Value.absent(),
                Value<String?> gender = const Value.absent(),
                Value<String?> bloodGroup = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<String?> emergencyContact = const Value.absent(),
                Value<String?> emergencyContactPhone = const Value.absent(),
                Value<String?> profilePhotoUrl = const Value.absent(),
                Value<String> allergies = const Value.absent(),
                Value<String> medications = const Value.absent(),
                Value<String> medicalHistory = const Value.absent(),
                Value<DateTime?> lastVisit = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<bool> isSynced = const Value.absent(),
                Value<DateTime?> lastSyncAt = const Value.absent(),
                Value<bool> pendingDelete = const Value.absent(),
                Value<String> syncVersion = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalPatientProfilesCompanion.insert(
                id: id,
                fullName: fullName,
                email: email,
                phoneNumber: phoneNumber,
                dateOfBirth: dateOfBirth,
                gender: gender,
                bloodGroup: bloodGroup,
                address: address,
                emergencyContact: emergencyContact,
                emergencyContactPhone: emergencyContactPhone,
                profilePhotoUrl: profilePhotoUrl,
                allergies: allergies,
                medications: medications,
                medicalHistory: medicalHistory,
                lastVisit: lastVisit,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isSynced: isSynced,
                lastSyncAt: lastSyncAt,
                pendingDelete: pendingDelete,
                syncVersion: syncVersion,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalPatientProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $LocalPatientProfilesTable,
      LocalPatientProfile,
      $$LocalPatientProfilesTableFilterComposer,
      $$LocalPatientProfilesTableOrderingComposer,
      $$LocalPatientProfilesTableAnnotationComposer,
      $$LocalPatientProfilesTableCreateCompanionBuilder,
      $$LocalPatientProfilesTableUpdateCompanionBuilder,
      (
        LocalPatientProfile,
        BaseReferences<
          _$LocalDatabase,
          $LocalPatientProfilesTable,
          LocalPatientProfile
        >,
      ),
      LocalPatientProfile,
      PrefetchHooks Function()
    >;
typedef $$LocalDoctorsTableCreateCompanionBuilder =
    LocalDoctorsCompanion Function({
      required String id,
      required String fullName,
      required String email,
      Value<String?> phoneNumber,
      required String specialization,
      Value<String?> qualification,
      Value<String?> experience,
      Value<String?> profilePhotoUrl,
      Value<String?> about,
      Value<double> rating,
      Value<int> totalReviews,
      required double consultationFee,
      Value<bool> isAvailable,
      Value<bool> isOnline,
      Value<String> availableSlots,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<bool> isSynced,
      Value<DateTime?> lastSyncAt,
      Value<bool> pendingDelete,
      Value<String> syncVersion,
      Value<int> rowid,
    });
typedef $$LocalDoctorsTableUpdateCompanionBuilder =
    LocalDoctorsCompanion Function({
      Value<String> id,
      Value<String> fullName,
      Value<String> email,
      Value<String?> phoneNumber,
      Value<String> specialization,
      Value<String?> qualification,
      Value<String?> experience,
      Value<String?> profilePhotoUrl,
      Value<String?> about,
      Value<double> rating,
      Value<int> totalReviews,
      Value<double> consultationFee,
      Value<bool> isAvailable,
      Value<bool> isOnline,
      Value<String> availableSlots,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<bool> isSynced,
      Value<DateTime?> lastSyncAt,
      Value<bool> pendingDelete,
      Value<String> syncVersion,
      Value<int> rowid,
    });

class $$LocalDoctorsTableFilterComposer
    extends Composer<_$LocalDatabase, $LocalDoctorsTable> {
  $$LocalDoctorsTableFilterComposer({
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

  ColumnFilters<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get specialization => $composableBuilder(
    column: $table.specialization,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get qualification => $composableBuilder(
    column: $table.qualification,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get experience => $composableBuilder(
    column: $table.experience,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get profilePhotoUrl => $composableBuilder(
    column: $table.profilePhotoUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get about => $composableBuilder(
    column: $table.about,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalReviews => $composableBuilder(
    column: $table.totalReviews,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get consultationFee => $composableBuilder(
    column: $table.consultationFee,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isAvailable => $composableBuilder(
    column: $table.isAvailable,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isOnline => $composableBuilder(
    column: $table.isOnline,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get availableSlots => $composableBuilder(
    column: $table.availableSlots,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get pendingDelete => $composableBuilder(
    column: $table.pendingDelete,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncVersion => $composableBuilder(
    column: $table.syncVersion,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalDoctorsTableOrderingComposer
    extends Composer<_$LocalDatabase, $LocalDoctorsTable> {
  $$LocalDoctorsTableOrderingComposer({
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

  ColumnOrderings<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get specialization => $composableBuilder(
    column: $table.specialization,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get qualification => $composableBuilder(
    column: $table.qualification,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get experience => $composableBuilder(
    column: $table.experience,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get profilePhotoUrl => $composableBuilder(
    column: $table.profilePhotoUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get about => $composableBuilder(
    column: $table.about,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalReviews => $composableBuilder(
    column: $table.totalReviews,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get consultationFee => $composableBuilder(
    column: $table.consultationFee,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isAvailable => $composableBuilder(
    column: $table.isAvailable,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isOnline => $composableBuilder(
    column: $table.isOnline,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get availableSlots => $composableBuilder(
    column: $table.availableSlots,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get pendingDelete => $composableBuilder(
    column: $table.pendingDelete,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncVersion => $composableBuilder(
    column: $table.syncVersion,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalDoctorsTableAnnotationComposer
    extends Composer<_$LocalDatabase, $LocalDoctorsTable> {
  $$LocalDoctorsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get fullName =>
      $composableBuilder(column: $table.fullName, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get specialization => $composableBuilder(
    column: $table.specialization,
    builder: (column) => column,
  );

  GeneratedColumn<String> get qualification => $composableBuilder(
    column: $table.qualification,
    builder: (column) => column,
  );

  GeneratedColumn<String> get experience => $composableBuilder(
    column: $table.experience,
    builder: (column) => column,
  );

  GeneratedColumn<String> get profilePhotoUrl => $composableBuilder(
    column: $table.profilePhotoUrl,
    builder: (column) => column,
  );

  GeneratedColumn<String> get about =>
      $composableBuilder(column: $table.about, builder: (column) => column);

  GeneratedColumn<double> get rating =>
      $composableBuilder(column: $table.rating, builder: (column) => column);

  GeneratedColumn<int> get totalReviews => $composableBuilder(
    column: $table.totalReviews,
    builder: (column) => column,
  );

  GeneratedColumn<double> get consultationFee => $composableBuilder(
    column: $table.consultationFee,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isAvailable => $composableBuilder(
    column: $table.isAvailable,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isOnline =>
      $composableBuilder(column: $table.isOnline, builder: (column) => column);

  GeneratedColumn<String> get availableSlots => $composableBuilder(
    column: $table.availableSlots,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get pendingDelete => $composableBuilder(
    column: $table.pendingDelete,
    builder: (column) => column,
  );

  GeneratedColumn<String> get syncVersion => $composableBuilder(
    column: $table.syncVersion,
    builder: (column) => column,
  );
}

class $$LocalDoctorsTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $LocalDoctorsTable,
          LocalDoctor,
          $$LocalDoctorsTableFilterComposer,
          $$LocalDoctorsTableOrderingComposer,
          $$LocalDoctorsTableAnnotationComposer,
          $$LocalDoctorsTableCreateCompanionBuilder,
          $$LocalDoctorsTableUpdateCompanionBuilder,
          (
            LocalDoctor,
            BaseReferences<_$LocalDatabase, $LocalDoctorsTable, LocalDoctor>,
          ),
          LocalDoctor,
          PrefetchHooks Function()
        > {
  $$LocalDoctorsTableTableManager(_$LocalDatabase db, $LocalDoctorsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalDoctorsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalDoctorsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalDoctorsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> fullName = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String?> phoneNumber = const Value.absent(),
                Value<String> specialization = const Value.absent(),
                Value<String?> qualification = const Value.absent(),
                Value<String?> experience = const Value.absent(),
                Value<String?> profilePhotoUrl = const Value.absent(),
                Value<String?> about = const Value.absent(),
                Value<double> rating = const Value.absent(),
                Value<int> totalReviews = const Value.absent(),
                Value<double> consultationFee = const Value.absent(),
                Value<bool> isAvailable = const Value.absent(),
                Value<bool> isOnline = const Value.absent(),
                Value<String> availableSlots = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<DateTime?> lastSyncAt = const Value.absent(),
                Value<bool> pendingDelete = const Value.absent(),
                Value<String> syncVersion = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalDoctorsCompanion(
                id: id,
                fullName: fullName,
                email: email,
                phoneNumber: phoneNumber,
                specialization: specialization,
                qualification: qualification,
                experience: experience,
                profilePhotoUrl: profilePhotoUrl,
                about: about,
                rating: rating,
                totalReviews: totalReviews,
                consultationFee: consultationFee,
                isAvailable: isAvailable,
                isOnline: isOnline,
                availableSlots: availableSlots,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isSynced: isSynced,
                lastSyncAt: lastSyncAt,
                pendingDelete: pendingDelete,
                syncVersion: syncVersion,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String fullName,
                required String email,
                Value<String?> phoneNumber = const Value.absent(),
                required String specialization,
                Value<String?> qualification = const Value.absent(),
                Value<String?> experience = const Value.absent(),
                Value<String?> profilePhotoUrl = const Value.absent(),
                Value<String?> about = const Value.absent(),
                Value<double> rating = const Value.absent(),
                Value<int> totalReviews = const Value.absent(),
                required double consultationFee,
                Value<bool> isAvailable = const Value.absent(),
                Value<bool> isOnline = const Value.absent(),
                Value<String> availableSlots = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<bool> isSynced = const Value.absent(),
                Value<DateTime?> lastSyncAt = const Value.absent(),
                Value<bool> pendingDelete = const Value.absent(),
                Value<String> syncVersion = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalDoctorsCompanion.insert(
                id: id,
                fullName: fullName,
                email: email,
                phoneNumber: phoneNumber,
                specialization: specialization,
                qualification: qualification,
                experience: experience,
                profilePhotoUrl: profilePhotoUrl,
                about: about,
                rating: rating,
                totalReviews: totalReviews,
                consultationFee: consultationFee,
                isAvailable: isAvailable,
                isOnline: isOnline,
                availableSlots: availableSlots,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isSynced: isSynced,
                lastSyncAt: lastSyncAt,
                pendingDelete: pendingDelete,
                syncVersion: syncVersion,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalDoctorsTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $LocalDoctorsTable,
      LocalDoctor,
      $$LocalDoctorsTableFilterComposer,
      $$LocalDoctorsTableOrderingComposer,
      $$LocalDoctorsTableAnnotationComposer,
      $$LocalDoctorsTableCreateCompanionBuilder,
      $$LocalDoctorsTableUpdateCompanionBuilder,
      (
        LocalDoctor,
        BaseReferences<_$LocalDatabase, $LocalDoctorsTable, LocalDoctor>,
      ),
      LocalDoctor,
      PrefetchHooks Function()
    >;
typedef $$LocalAppointmentsTableCreateCompanionBuilder =
    LocalAppointmentsCompanion Function({
      required String id,
      required String patientId,
      required String doctorId,
      Value<String?> doctorName,
      Value<String?> doctorSpecialization,
      required DateTime appointmentDate,
      required DateTime appointmentTime,
      Value<String> status,
      Value<String?> notes,
      Value<String?> patientSymptoms,
      required double consultationFee,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<bool> isSynced,
      Value<DateTime?> lastSyncAt,
      Value<bool> pendingDelete,
      Value<String> syncVersion,
      Value<int> rowid,
    });
typedef $$LocalAppointmentsTableUpdateCompanionBuilder =
    LocalAppointmentsCompanion Function({
      Value<String> id,
      Value<String> patientId,
      Value<String> doctorId,
      Value<String?> doctorName,
      Value<String?> doctorSpecialization,
      Value<DateTime> appointmentDate,
      Value<DateTime> appointmentTime,
      Value<String> status,
      Value<String?> notes,
      Value<String?> patientSymptoms,
      Value<double> consultationFee,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<bool> isSynced,
      Value<DateTime?> lastSyncAt,
      Value<bool> pendingDelete,
      Value<String> syncVersion,
      Value<int> rowid,
    });

class $$LocalAppointmentsTableFilterComposer
    extends Composer<_$LocalDatabase, $LocalAppointmentsTable> {
  $$LocalAppointmentsTableFilterComposer({
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

  ColumnFilters<String> get doctorId => $composableBuilder(
    column: $table.doctorId,
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

  ColumnFilters<DateTime> get appointmentDate => $composableBuilder(
    column: $table.appointmentDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get appointmentTime => $composableBuilder(
    column: $table.appointmentTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get patientSymptoms => $composableBuilder(
    column: $table.patientSymptoms,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get consultationFee => $composableBuilder(
    column: $table.consultationFee,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get pendingDelete => $composableBuilder(
    column: $table.pendingDelete,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncVersion => $composableBuilder(
    column: $table.syncVersion,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalAppointmentsTableOrderingComposer
    extends Composer<_$LocalDatabase, $LocalAppointmentsTable> {
  $$LocalAppointmentsTableOrderingComposer({
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

  ColumnOrderings<String> get doctorId => $composableBuilder(
    column: $table.doctorId,
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

  ColumnOrderings<DateTime> get appointmentDate => $composableBuilder(
    column: $table.appointmentDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get appointmentTime => $composableBuilder(
    column: $table.appointmentTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get patientSymptoms => $composableBuilder(
    column: $table.patientSymptoms,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get consultationFee => $composableBuilder(
    column: $table.consultationFee,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get pendingDelete => $composableBuilder(
    column: $table.pendingDelete,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncVersion => $composableBuilder(
    column: $table.syncVersion,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalAppointmentsTableAnnotationComposer
    extends Composer<_$LocalDatabase, $LocalAppointmentsTable> {
  $$LocalAppointmentsTableAnnotationComposer({
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

  GeneratedColumn<String> get doctorId =>
      $composableBuilder(column: $table.doctorId, builder: (column) => column);

  GeneratedColumn<String> get doctorName => $composableBuilder(
    column: $table.doctorName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get doctorSpecialization => $composableBuilder(
    column: $table.doctorSpecialization,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get appointmentDate => $composableBuilder(
    column: $table.appointmentDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get appointmentTime => $composableBuilder(
    column: $table.appointmentTime,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get patientSymptoms => $composableBuilder(
    column: $table.patientSymptoms,
    builder: (column) => column,
  );

  GeneratedColumn<double> get consultationFee => $composableBuilder(
    column: $table.consultationFee,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get pendingDelete => $composableBuilder(
    column: $table.pendingDelete,
    builder: (column) => column,
  );

  GeneratedColumn<String> get syncVersion => $composableBuilder(
    column: $table.syncVersion,
    builder: (column) => column,
  );
}

class $$LocalAppointmentsTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $LocalAppointmentsTable,
          LocalAppointment,
          $$LocalAppointmentsTableFilterComposer,
          $$LocalAppointmentsTableOrderingComposer,
          $$LocalAppointmentsTableAnnotationComposer,
          $$LocalAppointmentsTableCreateCompanionBuilder,
          $$LocalAppointmentsTableUpdateCompanionBuilder,
          (
            LocalAppointment,
            BaseReferences<
              _$LocalDatabase,
              $LocalAppointmentsTable,
              LocalAppointment
            >,
          ),
          LocalAppointment,
          PrefetchHooks Function()
        > {
  $$LocalAppointmentsTableTableManager(
    _$LocalDatabase db,
    $LocalAppointmentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalAppointmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalAppointmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalAppointmentsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> patientId = const Value.absent(),
                Value<String> doctorId = const Value.absent(),
                Value<String?> doctorName = const Value.absent(),
                Value<String?> doctorSpecialization = const Value.absent(),
                Value<DateTime> appointmentDate = const Value.absent(),
                Value<DateTime> appointmentTime = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> patientSymptoms = const Value.absent(),
                Value<double> consultationFee = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<DateTime?> lastSyncAt = const Value.absent(),
                Value<bool> pendingDelete = const Value.absent(),
                Value<String> syncVersion = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalAppointmentsCompanion(
                id: id,
                patientId: patientId,
                doctorId: doctorId,
                doctorName: doctorName,
                doctorSpecialization: doctorSpecialization,
                appointmentDate: appointmentDate,
                appointmentTime: appointmentTime,
                status: status,
                notes: notes,
                patientSymptoms: patientSymptoms,
                consultationFee: consultationFee,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isSynced: isSynced,
                lastSyncAt: lastSyncAt,
                pendingDelete: pendingDelete,
                syncVersion: syncVersion,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String patientId,
                required String doctorId,
                Value<String?> doctorName = const Value.absent(),
                Value<String?> doctorSpecialization = const Value.absent(),
                required DateTime appointmentDate,
                required DateTime appointmentTime,
                Value<String> status = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> patientSymptoms = const Value.absent(),
                required double consultationFee,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<bool> isSynced = const Value.absent(),
                Value<DateTime?> lastSyncAt = const Value.absent(),
                Value<bool> pendingDelete = const Value.absent(),
                Value<String> syncVersion = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalAppointmentsCompanion.insert(
                id: id,
                patientId: patientId,
                doctorId: doctorId,
                doctorName: doctorName,
                doctorSpecialization: doctorSpecialization,
                appointmentDate: appointmentDate,
                appointmentTime: appointmentTime,
                status: status,
                notes: notes,
                patientSymptoms: patientSymptoms,
                consultationFee: consultationFee,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isSynced: isSynced,
                lastSyncAt: lastSyncAt,
                pendingDelete: pendingDelete,
                syncVersion: syncVersion,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalAppointmentsTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $LocalAppointmentsTable,
      LocalAppointment,
      $$LocalAppointmentsTableFilterComposer,
      $$LocalAppointmentsTableOrderingComposer,
      $$LocalAppointmentsTableAnnotationComposer,
      $$LocalAppointmentsTableCreateCompanionBuilder,
      $$LocalAppointmentsTableUpdateCompanionBuilder,
      (
        LocalAppointment,
        BaseReferences<
          _$LocalDatabase,
          $LocalAppointmentsTable,
          LocalAppointment
        >,
      ),
      LocalAppointment,
      PrefetchHooks Function()
    >;
typedef $$LocalHealthRecordsTableCreateCompanionBuilder =
    LocalHealthRecordsCompanion Function({
      required String id,
      required String patientId,
      Value<String?> doctorId,
      Value<String?> appointmentId,
      required String recordType,
      required String title,
      Value<String?> description,
      Value<String?> attachmentUrl,
      Value<String> metadata,
      required DateTime recordDate,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<bool> isSynced,
      Value<DateTime?> lastSyncAt,
      Value<bool> pendingDelete,
      Value<String> syncVersion,
      Value<int> rowid,
    });
typedef $$LocalHealthRecordsTableUpdateCompanionBuilder =
    LocalHealthRecordsCompanion Function({
      Value<String> id,
      Value<String> patientId,
      Value<String?> doctorId,
      Value<String?> appointmentId,
      Value<String> recordType,
      Value<String> title,
      Value<String?> description,
      Value<String?> attachmentUrl,
      Value<String> metadata,
      Value<DateTime> recordDate,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<bool> isSynced,
      Value<DateTime?> lastSyncAt,
      Value<bool> pendingDelete,
      Value<String> syncVersion,
      Value<int> rowid,
    });

class $$LocalHealthRecordsTableFilterComposer
    extends Composer<_$LocalDatabase, $LocalHealthRecordsTable> {
  $$LocalHealthRecordsTableFilterComposer({
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

  ColumnFilters<String> get doctorId => $composableBuilder(
    column: $table.doctorId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get appointmentId => $composableBuilder(
    column: $table.appointmentId,
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

  ColumnFilters<String> get attachmentUrl => $composableBuilder(
    column: $table.attachmentUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get metadata => $composableBuilder(
    column: $table.metadata,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get recordDate => $composableBuilder(
    column: $table.recordDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get pendingDelete => $composableBuilder(
    column: $table.pendingDelete,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncVersion => $composableBuilder(
    column: $table.syncVersion,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalHealthRecordsTableOrderingComposer
    extends Composer<_$LocalDatabase, $LocalHealthRecordsTable> {
  $$LocalHealthRecordsTableOrderingComposer({
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

  ColumnOrderings<String> get doctorId => $composableBuilder(
    column: $table.doctorId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get appointmentId => $composableBuilder(
    column: $table.appointmentId,
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

  ColumnOrderings<String> get attachmentUrl => $composableBuilder(
    column: $table.attachmentUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get metadata => $composableBuilder(
    column: $table.metadata,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get recordDate => $composableBuilder(
    column: $table.recordDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get pendingDelete => $composableBuilder(
    column: $table.pendingDelete,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncVersion => $composableBuilder(
    column: $table.syncVersion,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalHealthRecordsTableAnnotationComposer
    extends Composer<_$LocalDatabase, $LocalHealthRecordsTable> {
  $$LocalHealthRecordsTableAnnotationComposer({
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

  GeneratedColumn<String> get doctorId =>
      $composableBuilder(column: $table.doctorId, builder: (column) => column);

  GeneratedColumn<String> get appointmentId => $composableBuilder(
    column: $table.appointmentId,
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

  GeneratedColumn<String> get attachmentUrl => $composableBuilder(
    column: $table.attachmentUrl,
    builder: (column) => column,
  );

  GeneratedColumn<String> get metadata =>
      $composableBuilder(column: $table.metadata, builder: (column) => column);

  GeneratedColumn<DateTime> get recordDate => $composableBuilder(
    column: $table.recordDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get pendingDelete => $composableBuilder(
    column: $table.pendingDelete,
    builder: (column) => column,
  );

  GeneratedColumn<String> get syncVersion => $composableBuilder(
    column: $table.syncVersion,
    builder: (column) => column,
  );
}

class $$LocalHealthRecordsTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $LocalHealthRecordsTable,
          LocalHealthRecord,
          $$LocalHealthRecordsTableFilterComposer,
          $$LocalHealthRecordsTableOrderingComposer,
          $$LocalHealthRecordsTableAnnotationComposer,
          $$LocalHealthRecordsTableCreateCompanionBuilder,
          $$LocalHealthRecordsTableUpdateCompanionBuilder,
          (
            LocalHealthRecord,
            BaseReferences<
              _$LocalDatabase,
              $LocalHealthRecordsTable,
              LocalHealthRecord
            >,
          ),
          LocalHealthRecord,
          PrefetchHooks Function()
        > {
  $$LocalHealthRecordsTableTableManager(
    _$LocalDatabase db,
    $LocalHealthRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalHealthRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalHealthRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalHealthRecordsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> patientId = const Value.absent(),
                Value<String?> doctorId = const Value.absent(),
                Value<String?> appointmentId = const Value.absent(),
                Value<String> recordType = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> attachmentUrl = const Value.absent(),
                Value<String> metadata = const Value.absent(),
                Value<DateTime> recordDate = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<DateTime?> lastSyncAt = const Value.absent(),
                Value<bool> pendingDelete = const Value.absent(),
                Value<String> syncVersion = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalHealthRecordsCompanion(
                id: id,
                patientId: patientId,
                doctorId: doctorId,
                appointmentId: appointmentId,
                recordType: recordType,
                title: title,
                description: description,
                attachmentUrl: attachmentUrl,
                metadata: metadata,
                recordDate: recordDate,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isSynced: isSynced,
                lastSyncAt: lastSyncAt,
                pendingDelete: pendingDelete,
                syncVersion: syncVersion,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String patientId,
                Value<String?> doctorId = const Value.absent(),
                Value<String?> appointmentId = const Value.absent(),
                required String recordType,
                required String title,
                Value<String?> description = const Value.absent(),
                Value<String?> attachmentUrl = const Value.absent(),
                Value<String> metadata = const Value.absent(),
                required DateTime recordDate,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<bool> isSynced = const Value.absent(),
                Value<DateTime?> lastSyncAt = const Value.absent(),
                Value<bool> pendingDelete = const Value.absent(),
                Value<String> syncVersion = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalHealthRecordsCompanion.insert(
                id: id,
                patientId: patientId,
                doctorId: doctorId,
                appointmentId: appointmentId,
                recordType: recordType,
                title: title,
                description: description,
                attachmentUrl: attachmentUrl,
                metadata: metadata,
                recordDate: recordDate,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isSynced: isSynced,
                lastSyncAt: lastSyncAt,
                pendingDelete: pendingDelete,
                syncVersion: syncVersion,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalHealthRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $LocalHealthRecordsTable,
      LocalHealthRecord,
      $$LocalHealthRecordsTableFilterComposer,
      $$LocalHealthRecordsTableOrderingComposer,
      $$LocalHealthRecordsTableAnnotationComposer,
      $$LocalHealthRecordsTableCreateCompanionBuilder,
      $$LocalHealthRecordsTableUpdateCompanionBuilder,
      (
        LocalHealthRecord,
        BaseReferences<
          _$LocalDatabase,
          $LocalHealthRecordsTable,
          LocalHealthRecord
        >,
      ),
      LocalHealthRecord,
      PrefetchHooks Function()
    >;
typedef $$SyncOperationsTableCreateCompanionBuilder =
    SyncOperationsCompanion Function({
      Value<int> id,
      required String tableNameColumn,
      required String recordId,
      required String operation,
      Value<String?> data,
      Value<bool> isCompleted,
      Value<int> retryCount,
      Value<DateTime?> lastRetryAt,
      Value<String?> errorMessage,
      required DateTime createdAt,
    });
typedef $$SyncOperationsTableUpdateCompanionBuilder =
    SyncOperationsCompanion Function({
      Value<int> id,
      Value<String> tableNameColumn,
      Value<String> recordId,
      Value<String> operation,
      Value<String?> data,
      Value<bool> isCompleted,
      Value<int> retryCount,
      Value<DateTime?> lastRetryAt,
      Value<String?> errorMessage,
      Value<DateTime> createdAt,
    });

class $$SyncOperationsTableFilterComposer
    extends Composer<_$LocalDatabase, $SyncOperationsTable> {
  $$SyncOperationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tableNameColumn => $composableBuilder(
    column: $table.tableNameColumn,
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

  ColumnFilters<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastRetryAt => $composableBuilder(
    column: $table.lastRetryAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncOperationsTableOrderingComposer
    extends Composer<_$LocalDatabase, $SyncOperationsTable> {
  $$SyncOperationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tableNameColumn => $composableBuilder(
    column: $table.tableNameColumn,
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

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastRetryAt => $composableBuilder(
    column: $table.lastRetryAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncOperationsTableAnnotationComposer
    extends Composer<_$LocalDatabase, $SyncOperationsTable> {
  $$SyncOperationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tableNameColumn => $composableBuilder(
    column: $table.tableNameColumn,
    builder: (column) => column,
  );

  GeneratedColumn<String> get recordId =>
      $composableBuilder(column: $table.recordId, builder: (column) => column);

  GeneratedColumn<String> get operation =>
      $composableBuilder(column: $table.operation, builder: (column) => column);

  GeneratedColumn<String> get data =>
      $composableBuilder(column: $table.data, builder: (column) => column);

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastRetryAt => $composableBuilder(
    column: $table.lastRetryAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$SyncOperationsTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $SyncOperationsTable,
          SyncOperation,
          $$SyncOperationsTableFilterComposer,
          $$SyncOperationsTableOrderingComposer,
          $$SyncOperationsTableAnnotationComposer,
          $$SyncOperationsTableCreateCompanionBuilder,
          $$SyncOperationsTableUpdateCompanionBuilder,
          (
            SyncOperation,
            BaseReferences<
              _$LocalDatabase,
              $SyncOperationsTable,
              SyncOperation
            >,
          ),
          SyncOperation,
          PrefetchHooks Function()
        > {
  $$SyncOperationsTableTableManager(
    _$LocalDatabase db,
    $SyncOperationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncOperationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncOperationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncOperationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> tableNameColumn = const Value.absent(),
                Value<String> recordId = const Value.absent(),
                Value<String> operation = const Value.absent(),
                Value<String?> data = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<int> retryCount = const Value.absent(),
                Value<DateTime?> lastRetryAt = const Value.absent(),
                Value<String?> errorMessage = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => SyncOperationsCompanion(
                id: id,
                tableNameColumn: tableNameColumn,
                recordId: recordId,
                operation: operation,
                data: data,
                isCompleted: isCompleted,
                retryCount: retryCount,
                lastRetryAt: lastRetryAt,
                errorMessage: errorMessage,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String tableNameColumn,
                required String recordId,
                required String operation,
                Value<String?> data = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<int> retryCount = const Value.absent(),
                Value<DateTime?> lastRetryAt = const Value.absent(),
                Value<String?> errorMessage = const Value.absent(),
                required DateTime createdAt,
              }) => SyncOperationsCompanion.insert(
                id: id,
                tableNameColumn: tableNameColumn,
                recordId: recordId,
                operation: operation,
                data: data,
                isCompleted: isCompleted,
                retryCount: retryCount,
                lastRetryAt: lastRetryAt,
                errorMessage: errorMessage,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncOperationsTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $SyncOperationsTable,
      SyncOperation,
      $$SyncOperationsTableFilterComposer,
      $$SyncOperationsTableOrderingComposer,
      $$SyncOperationsTableAnnotationComposer,
      $$SyncOperationsTableCreateCompanionBuilder,
      $$SyncOperationsTableUpdateCompanionBuilder,
      (
        SyncOperation,
        BaseReferences<_$LocalDatabase, $SyncOperationsTable, SyncOperation>,
      ),
      SyncOperation,
      PrefetchHooks Function()
    >;
typedef $$LocalAppSettingsTableCreateCompanionBuilder =
    LocalAppSettingsCompanion Function({
      required String key,
      required String value,
      required DateTime updatedAt,
      Value<bool> isSynced,
      Value<int> rowid,
    });
typedef $$LocalAppSettingsTableUpdateCompanionBuilder =
    LocalAppSettingsCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<DateTime> updatedAt,
      Value<bool> isSynced,
      Value<int> rowid,
    });

class $$LocalAppSettingsTableFilterComposer
    extends Composer<_$LocalDatabase, $LocalAppSettingsTable> {
  $$LocalAppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalAppSettingsTableOrderingComposer
    extends Composer<_$LocalDatabase, $LocalAppSettingsTable> {
  $$LocalAppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalAppSettingsTableAnnotationComposer
    extends Composer<_$LocalDatabase, $LocalAppSettingsTable> {
  $$LocalAppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);
}

class $$LocalAppSettingsTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $LocalAppSettingsTable,
          LocalAppSetting,
          $$LocalAppSettingsTableFilterComposer,
          $$LocalAppSettingsTableOrderingComposer,
          $$LocalAppSettingsTableAnnotationComposer,
          $$LocalAppSettingsTableCreateCompanionBuilder,
          $$LocalAppSettingsTableUpdateCompanionBuilder,
          (
            LocalAppSetting,
            BaseReferences<
              _$LocalDatabase,
              $LocalAppSettingsTable,
              LocalAppSetting
            >,
          ),
          LocalAppSetting,
          PrefetchHooks Function()
        > {
  $$LocalAppSettingsTableTableManager(
    _$LocalDatabase db,
    $LocalAppSettingsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalAppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalAppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalAppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalAppSettingsCompanion(
                key: key,
                value: value,
                updatedAt: updatedAt,
                isSynced: isSynced,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                required DateTime updatedAt,
                Value<bool> isSynced = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalAppSettingsCompanion.insert(
                key: key,
                value: value,
                updatedAt: updatedAt,
                isSynced: isSynced,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalAppSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $LocalAppSettingsTable,
      LocalAppSetting,
      $$LocalAppSettingsTableFilterComposer,
      $$LocalAppSettingsTableOrderingComposer,
      $$LocalAppSettingsTableAnnotationComposer,
      $$LocalAppSettingsTableCreateCompanionBuilder,
      $$LocalAppSettingsTableUpdateCompanionBuilder,
      (
        LocalAppSetting,
        BaseReferences<
          _$LocalDatabase,
          $LocalAppSettingsTable,
          LocalAppSetting
        >,
      ),
      LocalAppSetting,
      PrefetchHooks Function()
    >;
typedef $$LocalTodosTableCreateCompanionBuilder =
    LocalTodosCompanion Function({
      required String id,
      required String title,
      Value<String?> description,
      Value<bool> isCompleted,
      Value<int> priority,
      Value<DateTime?> dueDate,
      Value<DateTime?> completedAt,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<bool> isSynced,
      Value<DateTime?> lastSyncAt,
      Value<bool> pendingDelete,
      Value<String> syncVersion,
      Value<int> rowid,
    });
typedef $$LocalTodosTableUpdateCompanionBuilder =
    LocalTodosCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String?> description,
      Value<bool> isCompleted,
      Value<int> priority,
      Value<DateTime?> dueDate,
      Value<DateTime?> completedAt,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<bool> isSynced,
      Value<DateTime?> lastSyncAt,
      Value<bool> pendingDelete,
      Value<String> syncVersion,
      Value<int> rowid,
    });

class $$LocalTodosTableFilterComposer
    extends Composer<_$LocalDatabase, $LocalTodosTable> {
  $$LocalTodosTableFilterComposer({
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

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get pendingDelete => $composableBuilder(
    column: $table.pendingDelete,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncVersion => $composableBuilder(
    column: $table.syncVersion,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalTodosTableOrderingComposer
    extends Composer<_$LocalDatabase, $LocalTodosTable> {
  $$LocalTodosTableOrderingComposer({
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

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get pendingDelete => $composableBuilder(
    column: $table.pendingDelete,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncVersion => $composableBuilder(
    column: $table.syncVersion,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalTodosTableAnnotationComposer
    extends Composer<_$LocalDatabase, $LocalTodosTable> {
  $$LocalTodosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<int> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<DateTime> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get pendingDelete => $composableBuilder(
    column: $table.pendingDelete,
    builder: (column) => column,
  );

  GeneratedColumn<String> get syncVersion => $composableBuilder(
    column: $table.syncVersion,
    builder: (column) => column,
  );
}

class $$LocalTodosTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $LocalTodosTable,
          LocalTodo,
          $$LocalTodosTableFilterComposer,
          $$LocalTodosTableOrderingComposer,
          $$LocalTodosTableAnnotationComposer,
          $$LocalTodosTableCreateCompanionBuilder,
          $$LocalTodosTableUpdateCompanionBuilder,
          (
            LocalTodo,
            BaseReferences<_$LocalDatabase, $LocalTodosTable, LocalTodo>,
          ),
          LocalTodo,
          PrefetchHooks Function()
        > {
  $$LocalTodosTableTableManager(_$LocalDatabase db, $LocalTodosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalTodosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalTodosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalTodosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<int> priority = const Value.absent(),
                Value<DateTime?> dueDate = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<DateTime?> lastSyncAt = const Value.absent(),
                Value<bool> pendingDelete = const Value.absent(),
                Value<String> syncVersion = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalTodosCompanion(
                id: id,
                title: title,
                description: description,
                isCompleted: isCompleted,
                priority: priority,
                dueDate: dueDate,
                completedAt: completedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isSynced: isSynced,
                lastSyncAt: lastSyncAt,
                pendingDelete: pendingDelete,
                syncVersion: syncVersion,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                Value<String?> description = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<int> priority = const Value.absent(),
                Value<DateTime?> dueDate = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<bool> isSynced = const Value.absent(),
                Value<DateTime?> lastSyncAt = const Value.absent(),
                Value<bool> pendingDelete = const Value.absent(),
                Value<String> syncVersion = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalTodosCompanion.insert(
                id: id,
                title: title,
                description: description,
                isCompleted: isCompleted,
                priority: priority,
                dueDate: dueDate,
                completedAt: completedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isSynced: isSynced,
                lastSyncAt: lastSyncAt,
                pendingDelete: pendingDelete,
                syncVersion: syncVersion,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalTodosTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $LocalTodosTable,
      LocalTodo,
      $$LocalTodosTableFilterComposer,
      $$LocalTodosTableOrderingComposer,
      $$LocalTodosTableAnnotationComposer,
      $$LocalTodosTableCreateCompanionBuilder,
      $$LocalTodosTableUpdateCompanionBuilder,
      (LocalTodo, BaseReferences<_$LocalDatabase, $LocalTodosTable, LocalTodo>),
      LocalTodo,
      PrefetchHooks Function()
    >;

class $LocalDatabaseManager {
  final _$LocalDatabase _db;
  $LocalDatabaseManager(this._db);
  $$LocalPatientProfilesTableTableManager get localPatientProfiles =>
      $$LocalPatientProfilesTableTableManager(_db, _db.localPatientProfiles);
  $$LocalDoctorsTableTableManager get localDoctors =>
      $$LocalDoctorsTableTableManager(_db, _db.localDoctors);
  $$LocalAppointmentsTableTableManager get localAppointments =>
      $$LocalAppointmentsTableTableManager(_db, _db.localAppointments);
  $$LocalHealthRecordsTableTableManager get localHealthRecords =>
      $$LocalHealthRecordsTableTableManager(_db, _db.localHealthRecords);
  $$SyncOperationsTableTableManager get syncOperations =>
      $$SyncOperationsTableTableManager(_db, _db.syncOperations);
  $$LocalAppSettingsTableTableManager get localAppSettings =>
      $$LocalAppSettingsTableTableManager(_db, _db.localAppSettings);
  $$LocalTodosTableTableManager get localTodos =>
      $$LocalTodosTableTableManager(_db, _db.localTodos);
}
