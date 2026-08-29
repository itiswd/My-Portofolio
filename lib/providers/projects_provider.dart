import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/project_repository.dart';
import '../models/portfolio_project.dart';

final projectRepositoryProvider = Provider<ProjectRepository>((ref) {
  return ProjectRepository();
});

final publishedProjectsProvider =
    FutureProvider<List<PortfolioProject>>((ref) async {
  final repository = ref.watch(projectRepositoryProvider);
  return repository.getPublishedProjects();
});

class SelectedProjectCategoryNotifier extends Notifier<String> {
  @override
  String build() => 'All';

  void select(String category) => state = category;
}

final selectedProjectCategoryProvider =
    NotifierProvider<SelectedProjectCategoryNotifier, String>(
  SelectedProjectCategoryNotifier.new,
);
