from typing import Generic, TypeVar

T = TypeVar("T")

test = "ph"

def decorator(fn):
    return fn


@decorator
def build_message(prefix: str, value: int) -> str:
    local_value = f"{prefix}-{value}"
    print(local_value)
    return local_value


def outer_scope_demo(seed: int):
    outer_value = seed

    def inner() -> int:
        return outer_value + 1

    return inner()


class Example(Generic[T]):
    items: list[str]

    def __init__(self, items: list[str], default: T):
        self.items = items
        self.default = default

    def add_item(self, item: str) -> None:
        self.items.append(item)
        print(len(self.items), __name__)


example = Example[str](["one", "two"], "fallback")
example.add_item("three")
build_message("value", 7)
outer_scope_demo(4)
