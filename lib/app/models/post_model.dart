// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cartisan/app/data/constants/constants.dart';

class PostModel {
  String id;
  String uploadedBy;
  String uploaderImage;
  String location;
  String title;
  String description;
  String imageUrl;
  int quantity;
  double price;
  PostModel({
    required this.id,
    required this.uploadedBy,
    required this.uploaderImage,
    required this.location,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.quantity,
    required this.price,
  });
}

List<PostModel> posts = [
  PostModel(
    id: '1',
    uploadedBy: 'PastaRey Artisinal Foods',
    uploaderImage: 'https://randomuser.me/api/portraits/women/37.jpg',
    location: 'Menlo Park, CA',
    title: 'Spinach Gnocchi',
    description:
        'This creamy tomato pasta is a delicious five-ingredient recipe that adds cream cheese to the sauce. It  may sound a little unusual to add cream.',
    imageUrl: AppAssets.kProduct3,
    quantity: 20,
    price: 5.99,
  ),
  PostModel(
    id: '2',
    uploadedBy: 'Handy Crafts',
    uploaderImage: 'https://randomuser.me/api/portraits/men/3.jpg',
    location: 'Menlo Park, CA',
    title: 'Leaf Earrings',
    description:
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. ',
    imageUrl: AppAssets.kProduct1,
    quantity: 20,
    price: 25.99,
  ),
  PostModel(
    id: '3',
    uploadedBy: 'Fuzetea',
    uploaderImage: 'https://randomuser.me/api/portraits/men/94.jpg',
    location: 'Menlo Park, CA',
    title: 'Fuze Iced Tea ',
    description:
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. ',
    imageUrl: AppAssets.kProduct2,
    quantity: 20,
    price: 15.99,
  ),
];

List<PostModel> explore = [
  PostModel(
    id: '1',
    uploadedBy: '',
    uploaderImage: '',
    location: '',
    title: '',
    description: '',
    imageUrl: AppAssets.kProduct1,
    quantity: 1,
    price: 90,
  ),
  PostModel(
    id: '1',
    uploadedBy: '',
    uploaderImage: '',
    location: '',
    title: '',
    description: '',
    imageUrl: AppAssets.kProduct2,
    quantity: 1,
    price: 90,
  ),
  PostModel(
    id: '1',
    uploadedBy: '',
    uploaderImage: '',
    location: '',
    title: '',
    description: '',
    imageUrl: AppAssets.kProduct3,
    quantity: 1,
    price: 90,
  ),
  PostModel(
    id: '1',
    uploadedBy: '',
    uploaderImage: '',
    location: '',
    title: '',
    description: '',
    imageUrl: AppAssets.kProduct4,
    quantity: 1,
    price: 90,
  ),
  PostModel(
    id: '1',
    uploadedBy: '',
    uploaderImage: '',
    location: '',
    title: '',
    description: '',
    imageUrl: AppAssets.kProduct5,
    quantity: 1,
    price: 90,
  ),
  PostModel(
    id: '1',
    uploadedBy: '',
    uploaderImage: '',
    location: '',
    title: '',
    description: '',
    imageUrl: AppAssets.kProduct6,
    quantity: 1,
    price: 90,
  ),
  PostModel(
    id: '1',
    uploadedBy: '',
    uploaderImage: '',
    location: '',
    title: '',
    description: '',
    imageUrl: AppAssets.kProduct7,
    quantity: 1,
    price: 90,
  ),
  PostModel(
    id: '1',
    uploadedBy: '',
    uploaderImage: '',
    location: '',
    title: '',
    description: '',
    imageUrl: AppAssets.kProduct8,
    quantity: 1,
    price: 90,
  ),
  PostModel(
    id: '1',
    uploadedBy: '',
    uploaderImage: '',
    location: '',
    title: '',
    description: '',
    imageUrl: AppAssets.kProduct9,
    quantity: 1,
    price: 90,
  ),
  PostModel(
    id: '1',
    uploadedBy: '',
    uploaderImage: '',
    location: '',
    title: '',
    description: '',
    imageUrl: AppAssets.kProduct10,
    quantity: 1,
    price: 90,
  ),
];
