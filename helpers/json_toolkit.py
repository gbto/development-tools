class JSONToolkit():
    """A class that contains method useful for manipulating json."""

    def __init__():
        pass

    def search_json(self, lookup_key: str, object: dict | list, search_result=list()) -> list[dict]:
        """Extracts the values of a lookup key from a json file by recursively
        navigating the different level of the file."""

        if type(object) == dict:
            for key, value in object.items():
                if lookup_key.lower() in key.lower():
                    search_result.append(dict(key=value))
                self.search_json(lookup_key, value, search_result)

        elif type(object) == list:
            for element in object:
                self.search_json(lookup_key, element, search_result)

        return search_result

    def cleanup_json(self, lookup_key: str, object: dict | list) -> list[dict]:
        """Replaces the values of a lookup keys from a json file by recursively
        navigating """

        if type(object) == dict:
            for key, value in object.items():
                if lookup_key.lower() in key.lower():
                    object[key] = None
                self.cleanup_json(lookup_key, value)

        elif type(object) == list:
            for element in object:
                self.cleanup_json(lookup_key, element)

        return object
