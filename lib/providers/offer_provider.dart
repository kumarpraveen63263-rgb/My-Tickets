import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/offer_model.dart';
import '../data/repositories/offer_repository.dart';

final offerRepositoryProvider = Provider<OfferRepository>(
  (ref) => OfferRepository(),
);

final offersProvider = FutureProvider<List<OfferModel>>((ref) {
  return ref.watch(offerRepositoryProvider).getAll();
});
