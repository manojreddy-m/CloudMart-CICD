const products = [
  { name: "Cloud Laptop", price: 55000 },
  { name: "Smart Headphones", price: 2500 },
  { name: "Wireless Keyboard", price: 1800 }
];

const productContainer = document.getElementById("products");

products.forEach((product) => {
  const card = document.createElement("article");
  card.className = "product";

  const name = document.createElement("h3");
  name.textContent = product.name;

  const price = document.createElement("p");
  price.className = "price";
  price.textContent = `₹${product.price.toLocaleString("en-IN")}`;

  card.append(name, price);
  productContainer.appendChild(card);
});

fetch("/health")
  .then((response) => {
    if (!response.ok) throw new Error("Health check failed");
    return response.json();
  })
  .then((data) => {
    document.getElementById("health").textContent =
      `Application status: ${data.status}`;
  })
  .catch(() => {
    document.getElementById("health").textContent =
      "Application status unavailable";
  });
