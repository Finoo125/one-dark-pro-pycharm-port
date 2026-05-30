class ThemePreview {
  constructor(name, items = []) {
    this.name = name;
    this.items = items;
  }

  addItem(item) {
    const localValue = `${this.name}:${item}`;
    this.items.push(localValue);
    console.log(localValue);
    return localValue;
  }
}

function buildMessage(prefix, value) {
  const localValue = `${prefix}-${value}`;
  return localValue;
}

const preview = new ThemePreview("one-dark-pro");
preview.addItem("sample");
buildMessage("value", 7);
