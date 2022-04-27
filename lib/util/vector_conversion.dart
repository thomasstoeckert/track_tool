import 'package:flame/components.dart';
import 'package:vector_math/vector_math.dart' as classic_vectors;

extension VectorConversion on classic_vectors.Vector2 {
  Vector2 convert() {
    return Vector2(x, y);
  }
}

extension OtherVectorConversion on Vector2 {
  classic_vectors.Vector2 convert() {
    return classic_vectors.Vector2(x, y);
  }
}
