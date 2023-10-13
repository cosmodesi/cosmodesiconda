def test_torch():
    
    import random
    import torch
    import math


    class DynamicNet(torch.nn.Module):
        def __init__(self):
            """
            In the constructor we instantiate five parameters and assign them as members.
            """
            super().__init__()
            self.a = torch.nn.Parameter(torch.randn(()))
            self.b = torch.nn.Parameter(torch.randn(()))
            self.c = torch.nn.Parameter(torch.randn(()))
            self.d = torch.nn.Parameter(torch.randn(()))
            self.e = torch.nn.Parameter(torch.randn(()))

        def forward(self, x):
            """
            For the forward pass of the model, we randomly choose either 4, 5
            and reuse the e parameter to compute the contribution of these orders.

            Since each forward pass builds a dynamic computation graph, we can use normal
            Python control-flow operators like loops or conditional statements when
            defining the forward pass of the model.

            Here we also see that it is perfectly safe to reuse the same parameter many
            times when defining a computational graph.
            """
            y = self.a + self.b * x + self.c * x ** 2 + self.d * x ** 3
            for exp in range(4, random.randint(4, 6)):
                y = y + self.e * x ** exp
            return y

        def string(self):
            """
            Just like any class in Python, you can also define custom method on PyTorch modules
            """
            return f'y = {self.a.item()} + {self.b.item()} x + {self.c.item()} x^2 + {self.d.item()} x^3 + {self.e.item()} x^4 ? + {self.e.item()} x^5 ?'


    # Create Tensors to hold input and outputs.
    x = torch.linspace(-math.pi, math.pi, 2000)
    y = torch.sin(x)

    # Construct our model by instantiating the class defined above
    model = DynamicNet()

    # Construct our loss function and an Optimizer. Training this strange model with
    # vanilla stochastic gradient descent is tough, so we use momentum
    criterion = torch.nn.MSELoss(reduction='sum')
    optimizer = torch.optim.SGD(model.parameters(), lr=1e-8, momentum=0.9)
    for t in range(30000):
        # Forward pass: Compute predicted y by passing x to the model
        y_pred = model(x)

        # Compute and print loss
        loss = criterion(y_pred, y)
        if t % 2000 == 1999:
            print(t, loss.item())

        # Zero gradients, perform a backward pass, and update the weights.
        optimizer.zero_grad()
        loss.backward()
        optimizer.step()

    print(f'Result: {model.string()}')

    
def test_jax():
    
    import jax.numpy as jnp
    import jax
    import optax
    import functools

    @functools.partial(jax.vmap, in_axes=(None, 0))
    def network(params, x):
        return jnp.dot(params, x)

    def compute_loss(params, x, y):
        y_pred = network(params, x)
        loss = jnp.mean(optax.l2_loss(y_pred, y))
        return loss

    key = jax.random.PRNGKey(42)
    target_params = 0.5

    # Generate some data.
    xs = jax.random.normal(key, (16, 2))
    ys = jnp.sum(xs * target_params, axis=-1)

    start_learning_rate = 1e-1
    optimizer = optax.adam(start_learning_rate)

    # Initialize parameters of the model + optimizer.
    params = jnp.array([0.0, 0.0])
    opt_state = optimizer.init(params)

    # A simple update loop.
    for _ in range(1000):
        grads = jax.grad(compute_loss)(params, xs, ys)
        updates, opt_state = optimizer.update(grads, opt_state)
        params = optax.apply_updates(params, updates)

    assert jnp.allclose(params, target_params), \
    'Optimization should retrive the target params used to generate the data.'

    print(jax.default_backend(), jax.devices())
    
    
if __name__ == '__main__':

    test_jax()
    test_torch()