import 'package:pubnub/src/core/core.dart';

import 'package:pubnub/src/dx/_utils/utils.dart';
import 'package:pubnub/src/dx/_endpoints/objects/membership.dart';
import 'schema.dart';

final _logger = injectLogger('dx.objects.membership');

class MembershipDx {
  final Core _core;
  MembershipDx(this._core);

  /// Returns the specified user's space memberships,
  /// optionally including the custom data objects for: the user's perspective on their membership set ("custom"),
  /// the user's perspective on the space ("space"), and the space's custom data ("space.custom").
  ///
  /// Provide [include] List of additional/complex attributes to include in response.
  /// Omit this parameter if you don't want to retrieve additional attributes.
  ///
  /// Use [limit] to specify Number of objects to return in response.
  /// Default is 100, which is also the maximum value.
  ///
  /// [filter] is a Expression used to filter the results.
  /// Only objects whose properties satisfy the given expression are returned.
  ///
  /// Provide [start] and [end] for Previously-returned cursor bookmark for
  /// fetching the next/previous page.
  ///
  /// You can specify [count] to Request totalCount to be included in paginated response.
  /// By default, totalCount is omitted.
  ///
  /// You can provide [sort] List of attributes to sort by.
  /// Append :asc or :desc to an attribute to specify sort direction.
  /// The default sort direction is ascending.
  Future<MembershipsResult> getUserMemberships(String userId,
      {Set<String> include,
      int limit,
      String start,
      String end,
      bool count,
      String filter,
      Set<String> sort,
      Keyset keyset,
      String using}) async {
    keyset ??= _core.keysets.get(using, defaultIfNameIsNull: true);
    Ensure(keyset).isNotNull('keyset');

    Ensure(userId).isNotEmpty('userId');

    var params = GetMembershipsParams(keyset, userId,
        include: include,
        limit: limit,
        start: start,
        end: end,
        count: count,
        filter: filter,
        sort: sort);

    return defaultFlow<GetMembershipsParams, MembershipsResult>(
        logger: _logger,
        core: _core,
        params: params,
        serialize: (object, [_]) => MembershipsResult.fromJson(object));
  }

  /// Updates the specified user's space memberships.
  /// Use the add, update, and remove properties in the request body
  /// to perform those operations on one or more memberships.
  ///
  /// Provide [include] List of additional/complex attributes to include in response.
  /// Omit this parameter if you don't want to retrieve additional attributes.
  ///
  /// Use [limit] to specify Number of objects to return in response.
  /// Default is 100, which is also the maximum value.
  ///
  /// [filter] is a Expression used to filter the results.
  /// Only objects whose properties satisfy the given expression are returned.
  ///
  /// Provide [start] and [end] for Previously-returned cursor bookmark for
  /// fetching the next/previous page.
  ///
  /// You can specify [count] to Request totalCount to be included in paginated response.
  /// By default, totalCount is omitted.
  ///
  /// You can provide [sort] List of attributes to sort by.
  /// Append :asc or :desc to an attribute to specify sort direction.
  /// The default sort direction is ascending.
  ///
  /// Returns the user's space memberships, optionally including:
  /// * The user's custom data object
  /// * the custom data objects for the user's membership in each space
  ///   each space's custom data object Notes:
  /// * You can change all of the membership object's properties, except its ID.
  /// * Invalid property names are silently ignored and will not cause a request to fail.
  /// * If you update the "custom" property, you must completely replace it; partial updates are not supported.
  /// * The custom object can only contain scalar values
  Future<MembershipsResult> manageUserMemberships(String userId,
      {Set<String> add,
      List<UpdateInfo> update,
      Set<String> remove,
      Set<String> include,
      int limit,
      String start,
      String end,
      bool count,
      String filter,
      Set<String> sort,
      Keyset keyset,
      String using}) async {
    keyset ??= _core.keysets.get(using, defaultIfNameIsNull: true);
    Ensure(keyset).isNotNull('keyset');

    Ensure(userId).isNotEmpty('userId');

    var updates = <String, dynamic>{};
    if (add != null && add.isNotEmpty) {
      var addIds = <IdInfo>[];
      add.forEach((id) => addIds.add(IdInfo(id)));
      updates['add'] = addIds;
    }
    if (update != null && update.isNotEmpty) {
      updates['update'] = update;
    }
    if (remove != null && remove.isNotEmpty) {
      var removeIds = <IdInfo>[];
      remove.forEach((id) => removeIds.add(IdInfo(id)));
      updates['remove'] = removeIds;
    }
    var membershipChanges = await _core.parser.encode(updates);
    var params = ManageMembershipsParams(keyset, userId, membershipChanges,
        include: include,
        limit: limit,
        start: start,
        end: end,
        count: count,
        filter: filter,
        sort: sort);

    return defaultFlow<ManageMembershipsParams, MembershipsResult>(
        logger: _logger,
        core: _core,
        params: params,
        serialize: (object, [_]) => MembershipsResult.fromJson(object));
  }

  /// Use this method to add user's space memberships.
  /// [spaceIds] are List of space Ids to which you want to add the user [userId]
  ///
  /// Provide [include] List of additional/complex attributes to include in response.
  /// Omit this parameter if you don't want to retrieve additional attributes.
  ///
  /// Use [limit] to specify Number of objects to return in response.
  /// Default is 100, which is also the maximum value.
  ///
  /// [filter] is a Expression used to filter the results.
  /// Only objects whose properties satisfy the given expression are returned.
  ///
  /// Provide [start] and [end] for Previously-returned cursor bookmark for
  /// fetching the next/previous page.
  ///
  /// You can specify [count] to Request totalCount to be included in paginated response.
  /// By default, totalCount is omitted.
  ///
  /// You can provide [sort] List of attributes to sort by.
  /// Append :asc or :desc to an attribute to specify sort direction.
  /// The default sort direction is ascending.
  ///
  /// Returns the user's space memberships, optionally including:
  /// * The user's custom data object
  /// * the custom data objects for the user's membership in each space
  ///   each space's custom data object Notes:
  /// * Invalid property names are silently ignored and will not cause a request to fail.
  Future<MembershipsResult> addUserMemberships(
      String userId, List<String> spaceIds,
      {Set<String> include,
      int limit,
      String start,
      String end,
      bool count,
      String filter,
      Set<String> sort,
      Keyset keyset,
      String using}) async {
    keyset ??= _core.keysets.get(using, defaultIfNameIsNull: true);
    Ensure(keyset).isNotNull('keyset');

    Ensure(userId).isNotEmpty('userId');

    var updates = <String, dynamic>{};
    if (spaceIds.isNotEmpty) {
      var addIds = [];
      spaceIds.forEach((id) => addIds.add(IdInfo(id)));
      updates['add'] = addIds;
    }
    var membershipChanges = await _core.parser.encode(updates);
    var params = ManageMembershipsParams(keyset, userId, membershipChanges,
        include: include,
        limit: limit,
        start: start,
        end: end,
        count: count,
        filter: filter,
        sort: sort);

    return defaultFlow<ManageMembershipsParams, MembershipsResult>(
        logger: _logger,
        core: _core,
        params: params,
        serialize: (object, [_]) => MembershipsResult.fromJson(object));
  }

  /// Use this method to remove user's space memberships.
  /// It will remove user [userId] from all spaces specificed by [spaceIds]
  ///
  /// Provide [include] List of additional/complex attributes to include in response.
  /// Omit this parameter if you don't want to retrieve additional attributes.
  ///
  /// Use [limit] to specify Number of objects to return in response.
  /// Default is 100, which is also the maximum value.
  ///
  /// [filter] is a Expression used to filter the results.
  /// Only objects whose properties satisfy the given expression are returned.
  ///
  /// Provide [start] and [end] for Previously-returned cursor bookmark for
  /// fetching the next/previous page.
  ///
  /// You can specify [count] to Request totalCount to be included in paginated response.
  /// By default, totalCount is omitted.
  ///
  /// You can provide [sort] List of attributes to sort by.
  /// Append :asc or :desc to an attribute to specify sort direction.
  /// The default sort direction is ascending.
  ///
  /// Returns the user's space memberships, optionally including:
  /// * The user's custom data object
  /// * the custom data objects for the user's membership in each space
  ///   each space's custom data object Notes:
  /// * You can change all of the membership object's properties, except its ID.
  /// * Invalid property names are silently ignored and will not cause a request to fail.
  /// * If you update the "custom" property, you must completely replace it; partial updates are not supported.
  /// * The custom object can only contain scalar values
  Future<MembershipsResult> removeUserMemberships(
      String userId, List<String> spaceIds,
      {Set<String> include,
      int limit,
      String start,
      String end,
      bool count,
      String filter,
      Set<String> sort,
      Keyset keyset,
      String using}) async {
    keyset ??= _core.keysets.get(using, defaultIfNameIsNull: true);
    Ensure(keyset).isNotNull('keyset');

    Ensure(userId).isNotEmpty('userId');

    var updates = <String, dynamic>{};
    if (spaceIds.isNotEmpty) {
      var removeIds = <IdInfo>[];
      spaceIds.forEach((id) => removeIds.add(IdInfo(id)));
      updates['remove'] = removeIds;
    }
    var membershipChanges = await _core.parser.encode(updates);
    var params = ManageMembershipsParams(keyset, userId, membershipChanges,
        include: include,
        limit: limit,
        start: start,
        end: end,
        count: count,
        filter: filter,
        sort: sort);

    return defaultFlow<ManageMembershipsParams, MembershipsResult>(
        logger: _logger,
        core: _core,
        params: params,
        serialize: (object, [_]) => MembershipsResult.fromJson(object));
  }

  /// Use this method to update membership information of user with [userId]
  /// Provide list of [UpdateInfo] object which contains id and custom data which you want to update
  /// for that specific user's membership
  ///
  /// Provide [include] List of additional/complex attributes to include in response.
  /// Omit this parameter if you don't want to retrieve additional attributes.
  ///
  /// Use [limit] to specify Number of objects to return in response.
  /// Default is 100, which is also the maximum value.
  ///
  /// [filter] is a Expression used to filter the results.
  /// Only objects whose properties satisfy the given expression are returned.
  ///
  /// Provide [start] and [end] for Previously-returned cursor bookmark for
  /// fetching the next/previous page.
  ///
  /// You can specify [count] to Request totalCount to be included in paginated response.
  /// By default, totalCount is omitted.
  ///
  /// You can provide [sort] List of attributes to sort by.
  /// Append :asc or :desc to an attribute to specify sort direction.
  /// The default sort direction is ascending.
  ///
  /// Returns the user's space memberships, optionally including:
  /// * The user's custom data object
  /// * the custom data objects for the user's membership in each space
  ///   each space's custom data object Notes:
  /// * You can change all of the membership object's properties, except its ID.
  /// * Invalid property names are silently ignored and will not cause a request to fail.
  /// * If you update the "custom" property, you must completely replace it; partial updates are not supported.
  /// * The custom object can only contain scalar values
  Future<MembershipsResult> updateUserMemberships(
      String userId, List<UpdateInfo> update,
      {Set<String> include,
      int limit,
      String start,
      String end,
      bool count,
      String filter,
      Set<String> sort,
      Keyset keyset,
      String using}) async {
    keyset ??= _core.keysets.get(using, defaultIfNameIsNull: true);
    Ensure(keyset).isNotNull('keyset');

    Ensure(userId).isNotEmpty('userId');

    var updates = <String, dynamic>{};
    if (update.isNotEmpty) {
      updates['update'] = update;
    }
    var membershipChanges = await _core.parser.encode(updates);
    var params = ManageMembershipsParams(keyset, userId, membershipChanges,
        include: include,
        limit: limit,
        start: start,
        end: end,
        count: count,
        filter: filter,
        sort: sort);

    return defaultFlow<ManageMembershipsParams, MembershipsResult>(
        logger: _logger,
        core: _core,
        params: params,
        serialize: (object, [_]) => MembershipsResult.fromJson(object));
  }

  /// Returns the users in a space, optionally including:
  /// * Each user's custom data object
  /// * The custom data objects for each user's membership in the space
  /// * The space's custom data object
  ///
  /// Provide [include] List of additional/complex attributes to include in response.
  /// Omit this parameter if you don't want to retrieve additional attributes.
  ///
  /// Use [limit] to specify Number of objects to return in response.
  /// Default is 100, which is also the maximum value.
  ///
  /// [filter] is a Expression used to filter the results.
  /// Only objects whose properties satisfy the given expression are returned.
  ///
  /// Provide [start] and [end] for Previously-returned cursor bookmark for
  /// fetching the next/previous page.
  ///
  /// You can specify [count] to Request totalCount to be included in paginated response.
  /// By default, totalCount is omitted.
  ///
  /// You can provide [sort] List of attributes to sort by.
  /// Append :asc or :desc to an attribute to specify sort direction.
  /// The default sort direction is ascending.
  Future<SpaceMembersResult> getSpaceMembers(String spaceId,
      {Set<String> include,
      int limit,
      String start,
      String end,
      bool count,
      String filter,
      Set<String> sort,
      Keyset keyset,
      String using}) async {
    keyset ??= _core.keysets.get(using, defaultIfNameIsNull: true);
    Ensure(keyset).isNotNull('keyset');

    Ensure(spaceId).isNotEmpty('spaceId');
    var params = GetSpaceMembersParams(keyset, spaceId,
        include: include,
        limit: limit,
        start: start,
        end: end,
        count: count,
        filter: filter,
        sort: sort);

    return defaultFlow<GetSpaceMembersParams, SpaceMembersResult>(
        logger: _logger,
        core: _core,
        params: params,
        serialize: (object, [_]) => SpaceMembersResult.fromJson(object));
  }

  /// Updates the specified space's user list.
  /// Use the add, update, and remove properties in the request body to perform those operations on one or more memberships.
  ///
  /// Provide [include] List of additional/complex attributes to include in response.
  /// Omit this parameter if you don't want to retrieve additional attributes.
  ///
  /// Use [limit] to specify Number of objects to return in response.
  /// Default is 100, which is also the maximum value.
  ///
  /// [filter] is a Expression used to filter the results.
  /// Only objects whose properties satisfy the given expression are returned.
  ///
  /// Provide [start] and [end] for Previously-returned cursor bookmark for
  /// fetching the next/previous page.
  ///
  /// You can specify [count] to Request totalCount to be included in paginated response.
  /// By default, totalCount is omitted.
  ///
  /// You can provide [sort] List of attributes to sort by.
  /// Append :asc or :desc to an attribute to specify sort direction.
  /// The default sort direction is ascending.
  ///
  /// Returns the space's user memberships, optionally including:
  /// * The space's custom data object
  /// * The custom data objects for each user's membership in the space
  /// * Each user's custom data object Notes:
  /// * You can change all of the membership object's properties, except its ID.
  /// * Invalid property names are silently ignored and will not cause a request to fail.
  /// * If you update the "custom" property, you must completely replace it; partial updates are not supported.
  /// *  The custom object can only contain scalar values.
  Future<SpaceMembersResult> manageSpaceMembers(String spaceId,
      {Set<String> add,
      List<UpdateInfo> update,
      Set<String> remove,
      Set<String> include,
      int limit,
      String start,
      String end,
      bool count,
      String filter,
      Set<String> sort,
      Keyset keyset,
      String using}) async {
    keyset ??= _core.keysets.get(using, defaultIfNameIsNull: true);
    Ensure(keyset).isNotNull('keyset');

    Ensure(spaceId).isNotEmpty('spaceId');

    var updates = <String, dynamic>{};
    if (add != null && add.isNotEmpty) {
      var addIds = <IdInfo>[];
      add.forEach((id) => addIds.add(IdInfo(id)));
      updates['add'] = addIds;
    }
    if (update != null && update.isNotEmpty) {
      updates['update'] = update;
    }
    if (remove != null && remove.isNotEmpty) {
      var removeIds = <IdInfo>[];
      remove.forEach((id) => removeIds.add(IdInfo(id)));
      updates['remove'] = removeIds;
    }

    var spaceMembersChanges = await _core.parser.encode(updates);
    var params = ManageSpaceMembersParams(keyset, spaceId, spaceMembersChanges,
        include: include,
        limit: limit,
        start: start,
        end: end,
        count: count,
        filter: filter,
        sort: sort);

    return defaultFlow<ManageSpaceMembersParams, SpaceMembersResult>(
        logger: _logger,
        core: _core,
        params: params,
        serialize: (object, [_]) => SpaceMembersResult.fromJson(object));
  }
}
