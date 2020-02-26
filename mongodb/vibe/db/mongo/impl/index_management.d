module vibe.db.mongo.impl.index_management;

import vibe.data.bson;

/// Implementation of https://github.com/mongodb/specifications/blob/edb7e12e12ec5cea6536d4c17fbea3a0704d798d/source/index-management.rst
/// Minimum Server Version: 2.4
mixin template MongoIndexManagementImpl()
{
	import std.range : isInputRange, ElementType;

	/**
		Creates indexes on collections.

		See_Also: https://docs.mongodb.com/manual/reference/method/db.collection.createIndex/#db.collection.createIndex, IndexModel
	*/
	string createIndex(Bson keys, IndexOptions options = IndexOptions.init)
	@safe {
		return createIndex(IndexModel(keys, options));
	}

	/// ditto
	string createIndex(IndexModel model)
	@safe {
		return createIndexes([model])[0];
	}

	/// Creates one or more indexes on a collection.
	/// See_Also: https://docs.mongodb.com/manual/reference/method/db.collection.createIndexes/#db.collection.createIndexes, createIndex, IndexModel
	string[] createIndexes()(IndexModels models) @safe
			if (isInputRange!IndexModels && is(ElementType!IndexModels : IndexModel))
	{
		return null;
	}

	void dropIndex(string name)
	@safe {

	}
}

/// See_Also: https://github.com/mongodb/specifications/blob/edb7e12e12ec5cea6536d4c17fbea3a0704d798d/source/index-management.rst#common-api-components
struct IndexModel
{
	/**
		A document that contains the field and value pairs where the field is the index key and the value describes the type of index for that field. For an ascending index on a field, specify a value of 1; for descending index, specify a value of -1.

		Starting in 3.6, you cannot specify * as the index name.
	*/
	Bson keys;

	/**
		Optional. A document that contains a set of options that controls the creation of the index.
	*/
	IndexOptions options;
}

/// See_Also: https://github.com/mongodb/specifications/blob/edb7e12e12ec5cea6536d4c17fbea3a0704d798d/source/index-management.rst#common-api-components
struct IndexOptions
{
	/// Optionally tells the server to build the index in the background and not block other tasks.
	bool background;
	/// Optionally specifies the length in time, in seconds, for documents to remain in a collection.
	int expireAfter;
	/**
		Optionally specify a specific name for the index outside of the default generated name.
		If none is provided then the name is generated in the format "[field]_[direction]".

		Note that if an index is created for the same key pattern with different collations,
		a name must be provided by the user to avoid ambiguity.

		Examples: For an index of name: 1, age: -1, the generated name would be "name_1_age_-1".
	*/
	string name;
	/// Optionally tells the index to only reference documents with the specified field in the index.
	bool sparse;
	/// Optionally used only in MongoDB 3.0.0 and higher. Specifies the storage engine to store the index in.
	string storageEngine;
	/// Optionally forces the index to be unique.
	bool unique;
	/// Optionally specifies the index version number, either 0 or 1.
	int version_;
	/// Optionally specifies the default language for text indexes. Is english if none is provided.
	string defaultLanguage;
	/// Optionally Specifies the field in the document to override the language.
	string languageOverride;
	/// Optionally provides the text index version number.
	int textVersion;
	/// Optionally specifies fields in the index and their corresponding weight values.
	Bson weights;
	/// Optionally specifies the 2dsphere index version number.
	int sphereVersion;
	/// Optionally specifies the precision of the stored geo hash in the 2d index, from 1 to 32.
	int bits;
	/// Optionally sets the maximum boundary for latitude and longitude in the 2d index.
	double max = 0;
	/// Optionally sets the minimum boundary for latitude and longitude in the index in a 2d index.
	double min = 0;
	/// Optionally specifies the number of units within which to group the location values in a geo haystack index.
	int bucketSize;
	/// Optionally specifies a filter for use in a partial index. Only documents that match the filter expression are included in the index.
	Bson partialFilterExpression;
	/**
		Optionally specifies a collation to use for the index in MongoDB 3.4 and higher.
		If not specified, no collation is sent and the default collation of the collection server-side is used.
	*/
	Bson collation;
}
