import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gapp_bloc/blocs/cart/cart_event.dart';
import 'package:gapp_bloc/blocs/product/product_event.dart';
import 'package:gapp_bloc/blocs/product/product_state.dart';
import 'package:gapp_bloc/screens/product_details_screen.dart';
import 'package:gapp_bloc/screens/profile_screen.dart';
import 'package:gapp_bloc/screens/wishlist_screen.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/product/product_bloc.dart';
import '../auth/login_screen.dart';
import '../../blocs/cart/cart_bloc.dart';
import '../cart_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  
  final List<Widget> _screens = [
    const ProductListScreen(),
    const WishlistScreen(),
    const CartScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(LoadProducts());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthInitial) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const LoginScreen()),
            (route) => false,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Shop'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                context.read<AuthBloc>().add(SignOutRequested());
              },
            ),
          ],
        ),
        body: _screens[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
            if (index == 0) {
      context.read<ProductBloc>().add(LoadProducts());
    }
          },
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Wishlist',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: 'Cart',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;

    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state is ProductLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is ProductLoaded) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Products'),
            ),
            body: GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: state.products.length,
              itemBuilder: (context, index) {
                final product = state.products[index];
                final bool isInWishlist = state.wishlistIds.contains(product.id);
                return Card(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailsScreen(product: product),
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Stack(
                            children: [
                                SizedBox(
                                width: double.infinity,
                                height: double.infinity,
                                child: Image.network(
                                  product.imageUrl,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.name,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              if (product.isOnSale) ...[
                                Text(
                                  '\₹${product.discountPrice}',
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '\₹${product.price}',
                                  style: const TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              ] else
                                Text('\₹${product.price}'),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                                IconButton(
                                  icon: Icon(
                                    isInWishlist ? Icons.favorite : Icons.favorite_border,
                                    color: isInWishlist ? Colors.red : null,
                                  ),
                                  onPressed: () {
                                    if (authState is AuthSuccess) {
                                      context.read<ProductBloc>().add(
                                        isInWishlist
                                            ? RemoveFromWishlist(authState.user.id, product.id)
                                            : AddToWishlist(authState.user.id, product),
                                      );
                                    }
                                  },
                                ),
                              IconButton(
                                icon: const Icon(Icons.shopping_cart),
                                onPressed: () {
                                  if (authState is AuthSuccess) {
                                    context.read<CartBloc>().add(
                                      AddToCart(authState.user.id, product),
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('added to cart'),
                                        duration: Duration(seconds: 1),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }
        if (state is ProductError) {
          return Center(child: Text(state.message));
        }
        return const Center(child: Text('Something went wrong'));
      },
    );
  }
}
